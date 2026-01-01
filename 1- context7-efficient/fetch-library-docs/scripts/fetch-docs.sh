#!/bin/bash
# Main orchestrator: Token-efficient documentation fetcher
#
# This script achieves 77%+ token savings by:
# 1. Fetching raw docs (stays in shell subprocess)
# 2. Filtering with grep/awk/sed (0 LLM tokens!)
# 3. Returning condensed output to Claude
#
# Errors are returned as structured messages for Claude to handle

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load helpers
source "$SCRIPT_DIR/load-api-key.sh"

# Detect Python command early
PYTHON_CMD=$(get_python_cmd)
if [ -z "$PYTHON_CMD" ]; then
  echo "[PYTHON_NOT_FOUND]"
  echo ""
  echo "Python 3 is required but not found on this system."
  echo ""
  echo "Please install Python 3:"
  echo "  Windows: https://www.python.org/downloads/"
  echo "  macOS:   brew install python3"
  echo "  Linux:   sudo apt install python3"
  exit 1
fi

# Build MCP command with API key (if available)
MCP_CMD=$(build_mcp_command)

# Parse arguments
LIBRARY_ID=""
LIBRARY_NAME=""
TOPIC=""
MODE="code"
PAGE=1
VERBOSE=0

usage() {
  cat << USAGE
Usage: $0 [OPTIONS]

Token-efficient documentation fetcher using Context7 MCP

OPTIONS:
  --library-id ID    Context7 library ID (e.g., /reactjs/react.dev)
  --library NAME     Library name (will resolve to ID)
  --topic TOPIC      Topic to focus on (e.g., hooks, routing)
  --mode MODE        Mode: code (default) or info
  --page NUM         Page number (1-10, default: 1)
  --verbose, -v      Show token statistics
  --help, -h         Show this help

API KEY OPTIONS:
  --api-status       Check API key configuration status

EXAMPLES:
  $0 --library react --topic useState
  $0 --library-id /vercel/next.js --topic routing
  $0 --library prisma --topic queries --mode info
USAGE
  exit 0
}

# Show API key status
show_api_status() {
  echo "Context7 API Key Status"
  echo "======================="
  echo ""
  if has_api_key; then
    local key=$(load_context7_api_key)
    local masked="${key:0:12}...${key: -4}"
    echo "Status: CONFIGURED"
    echo "Key: $masked"
    echo "Source: $(get_api_key_source)"
  else
    echo "Status: NOT CONFIGURED"
    echo ""
    echo "To configure, save your API key:"
    echo "  echo \"CONTEXT7_API_KEY=your_key\" > ~/.context7.env"
    echo ""
    echo "Get a free API key at: https://context7.com/dashboard"
  fi
  exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --api-status)
      show_api_status
      ;;
    --library-id)
      LIBRARY_ID="$2"
      shift 2
      ;;
    --library)
      LIBRARY_NAME="$2"
      shift 2
      ;;
    --topic)
      TOPIC="$2"
      shift 2
      ;;
    --mode)
      MODE="$2"
      shift 2
      ;;
    --page)
      PAGE="$2"
      shift 2
      ;;
    -v|--verbose)
      VERBOSE=1
      shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      ;;
  esac
done

# Show status in verbose mode
if [ $VERBOSE -eq 1 ]; then
  if has_api_key; then
    echo "[INFO] API Key: configured ($(get_api_key_source))" >&2
  else
    echo "[WARNING] API Key: not configured" >&2
  fi
  echo "[INFO] Python: $PYTHON_CMD" >&2
fi

# Resolve library if name provided
if [ -n "${LIBRARY_NAME:-}" ] && [ -z "$LIBRARY_ID" ]; then
  [ $VERBOSE -eq 1 ] && echo "[INFO] Resolving library: $LIBRARY_NAME" >&2

  # Call resolve-library-id (requires both query and libraryName)
  RESOLVE_OUTPUT=$("$PYTHON_CMD" "$SCRIPT_DIR/mcp-client.py" call \
    -s "$MCP_CMD" \
    -t resolve-library-id \
    -p "{\"query\": \"$TOPIC\", \"libraryName\": \"$LIBRARY_NAME\"}" 2>&1) || {

    # Check if it's an API key issue
    if ! has_api_key; then
      echo "[CONTEXT7_API_KEY_MISSING]"
      echo ""
      api_key_error_message
      exit 1
    fi

    echo "[RESOLVE_ERROR]"
    echo ""
    echo "Failed to resolve library name: $LIBRARY_NAME"
    echo ""
    echo "Error: $RESOLVE_OUTPUT"
    exit 1
  }

  # Extract text from JSON
  if command -v jq &> /dev/null; then
    RESOLVE_TEXT=$(echo "$RESOLVE_OUTPUT" | jq -r '.content[0].text // empty' 2>/dev/null || echo "")
  else
    RESOLVE_TEXT=$(echo "$RESOLVE_OUTPUT" | "$PYTHON_CMD" -c 'import sys, json; data=json.load(sys.stdin); print(data.get("content", [{}])[0].get("text", ""))' 2>/dev/null || echo "")
  fi

  # Extract first library ID
  LIBRARY_ID=$(echo "$RESOLVE_TEXT" | grep -oP 'Context7-compatible library ID:\s*\K[/\w.-]+' 2>/dev/null | head -n 1 || echo "")

  if [ -z "$LIBRARY_ID" ]; then
    echo "[LIBRARY_NOT_FOUND]"
    echo ""
    echo "Could not find library: $LIBRARY_NAME"
    echo ""
    echo "Try:"
    echo "  - Different spelling (e.g., 'nextjs' instead of 'next.js')"
    echo "  - Using --library-id with exact ID"
    echo ""
    echo "Common library IDs:"
    echo "  React:    /reactjs/react.dev"
    echo "  Next.js:  /vercel/next.js"
    echo "  Express:  /expressjs/express"
    echo "  Prisma:   /prisma/docs"
    exit 1
  fi

  [ $VERBOSE -eq 1 ] && echo "[INFO] Resolved to: $LIBRARY_ID" >&2
fi

# Validate library ID
if [ -z "$LIBRARY_ID" ]; then
  echo "[MISSING_ARGUMENT]"
  echo ""
  echo "Must specify --library-id or --library"
  echo ""
  echo "Examples:"
  echo "  --library react --topic hooks"
  echo "  --library-id /reactjs/react.dev --topic useState"
  exit 1
fi

# Step 1: Fetch raw documentation
[ $VERBOSE -eq 1 ] && echo "[INFO] Fetching documentation..." >&2

RAW_OUTPUT=$("$SCRIPT_DIR/fetch-raw.sh" "$LIBRARY_ID" "$TOPIC" "$MODE" "$PAGE" 2>&1) || {
  # fetch-raw.sh already formats error messages
  echo "$RAW_OUTPUT"
  exit 1
}

# Check if output starts with error marker
if [[ "$RAW_OUTPUT" == "["* ]] && [[ "$RAW_OUTPUT" == *"_ERROR]"* || "$RAW_OUTPUT" == *"_MISSING]"* || "$RAW_OUTPUT" == *"_NOT_FOUND]"* ]]; then
  echo "$RAW_OUTPUT"
  exit 1
fi

# Step 2: Extract text from JSON
if command -v jq &> /dev/null; then
  RAW_TEXT=$(echo "$RAW_OUTPUT" | jq -r '.content[0].text // empty' 2>/dev/null || echo "")
else
  RAW_TEXT=$(echo "$RAW_OUTPUT" | "$PYTHON_CMD" -c 'import sys, json; data=json.load(sys.stdin); print(data.get("content", [{}])[0].get("text", ""))' 2>/dev/null || echo "")
fi

if [ -z "$RAW_TEXT" ]; then
  echo "[NO_CONTENT]"
  echo ""
  echo "No documentation content received from Context7."
  echo ""
  echo "This may be due to:"
  echo "  - Invalid library ID"
  echo "  - API rate limiting (get API key at context7.com/dashboard)"
  echo "  - Temporary service issue"
  echo ""
  echo "Raw response: $RAW_OUTPUT"
  exit 1
fi

# Calculate raw token count (approximate: words * 1.3)
if [ $VERBOSE -eq 1 ]; then
  RAW_WORDS=$(echo "$RAW_TEXT" | wc -w)
  RAW_TOKENS=$((RAW_WORDS * 13 / 10))
  echo "[INFO] Raw response: ~$RAW_WORDS words (~$RAW_TOKENS tokens)" >&2
fi

# Step 3: Filter using shell tools (0 LLM tokens!)
OUTPUT=""

if [ "$MODE" = "code" ]; then
  # Code mode: Extract code examples and API signatures
  CODE_BLOCKS=$(echo "$RAW_TEXT" | "$SCRIPT_DIR/extract-code-blocks.sh" 5 2>/dev/null || echo "")

  if [ -n "$CODE_BLOCKS" ] && [ "$CODE_BLOCKS" != "# No code blocks found" ]; then
    OUTPUT+="## Code Examples\n\n$CODE_BLOCKS\n"
  fi

  SIGNATURES=$(echo "$RAW_TEXT" | "$SCRIPT_DIR/extract-signatures.sh" 3 2>/dev/null || echo "")

  if [ -n "$SIGNATURES" ]; then
    OUTPUT+="\n## API Signatures\n\n$SIGNATURES\n"
  fi
else
  # Info mode: Extract conceptual content
  CODE_BLOCKS=$(echo "$RAW_TEXT" | "$SCRIPT_DIR/extract-code-blocks.sh" 2 2>/dev/null || echo "")

  if [ -n "$CODE_BLOCKS" ] && [ "$CODE_BLOCKS" != "# No code blocks found" ]; then
    OUTPUT+="## Examples\n\n$CODE_BLOCKS\n"
  fi

  OVERVIEW=$(echo "$RAW_TEXT" | \
    awk 'BEGIN{RS=""; FS="\n"} length($0) > 200 && !/```/{print; if(++count>=3) exit}' 2>/dev/null || echo "")

  if [ -n "$OVERVIEW" ]; then
    OUTPUT+="\n## Overview\n\n$OVERVIEW\n"
  fi
fi

# Always add important notes
NOTES=$(echo "$RAW_TEXT" | "$SCRIPT_DIR/extract-notes.sh" 3 2>/dev/null || echo "")

if [ -n "$NOTES" ]; then
  OUTPUT+="\n## Important Notes\n\n$NOTES\n"
fi

# Fallback if no content extracted
if [ -z "$OUTPUT" ]; then
  OUTPUT=$(echo "$RAW_TEXT" | head -c 1000)
  OUTPUT+="\n\n[Content truncated]"
fi

# Step 4: Output filtered content
echo -e "$OUTPUT"

# Show token savings in verbose mode
if [ $VERBOSE -eq 1 ]; then
  FILTERED_WORDS=$(echo -e "$OUTPUT" | wc -w)
  FILTERED_TOKENS=$((FILTERED_WORDS * 13 / 10))
  if [ $RAW_TOKENS -gt 0 ]; then
    SAVINGS=$(( (RAW_TOKENS - FILTERED_TOKENS) * 100 / RAW_TOKENS ))
  else
    SAVINGS=0
  fi

  echo "" >&2
  echo "[INFO] Filtered output: ~$FILTERED_WORDS words (~$FILTERED_TOKENS tokens)" >&2
  echo "[INFO] Token savings: ${SAVINGS}%" >&2
fi
