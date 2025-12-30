#!/bin/bash
# Main orchestrator: Token-efficient documentation fetcher using HTTP API
#
# This script achieves 86.8% token savings by:
# 1. Fetching docs via HTTP API (response stays in shell)
# 2. Filtering with grep/awk/sed (0 LLM tokens!)
# 3. Returning condensed output (~350 tokens to Claude)
#
# Requires: CONTEXT7_API_KEY environment variable
# Get your API key at: https://context7.com/dashboard

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Parse arguments
LIBRARY_ID=""
LIBRARY_NAME=""
TOPIC=""
MODE="code"
TOKENS=5000
VERBOSE=0

usage() {
  cat << USAGE
Usage: $0 [OPTIONS]

Token-efficient documentation fetcher using Context7 HTTP API

OPTIONS:
  --library-id ID    Context7 library ID (e.g., /vercel/next.js)
  --library NAME     Library name (will resolve to ID)
  --topic TOPIC      Topic to focus on (e.g., hooks, routing)
  --mode MODE        Mode: code (default) or info
  --tokens NUM       Max tokens from API (default: 5000)
  --verbose, -v      Show token statistics
  --help, -h         Show this help

EXAMPLES:
  # Quick lookup with known library ID
  $0 --library-id /reactjs/react.dev --topic useState

  # Resolve library name first
  $0 --library react --topic hooks --mode code

  # Get conceptual info
  $0 --library-id /prisma/docs --topic "getting started" --mode info

ENVIRONMENT:
  CONTEXT7_API_KEY   Required: Your Context7 API key
                     Get yours at: https://context7.com/dashboard

USAGE
  exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
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
    --tokens)
      TOKENS="$2"
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

# Check for API key
if [ -z "${CONTEXT7_API_KEY:-}" ]; then
  # Try loading from .env file
  ENV_FILE="$SCRIPT_DIR/../.env"
  if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
  fi
fi

if [ -z "${CONTEXT7_API_KEY:-}" ]; then
  echo "Error: CONTEXT7_API_KEY not set" >&2
  echo "Get your API key at: https://context7.com/dashboard" >&2
  echo "Set it in environment or in .env file" >&2
  exit 1
fi

# Validate topic
if [ -z "${TOPIC:-}" ]; then
  echo "Error: --topic is required" >&2
  usage
fi

# Resolve library if name provided
if [ -n "${LIBRARY_NAME:-}" ] && [ -z "$LIBRARY_ID" ]; then
  [ $VERBOSE -eq 1 ] && echo "Resolving library: $LIBRARY_NAME..." >&2

  # Call HTTP API to resolve library
  RESOLVE_OUTPUT=$(python3 "$SCRIPT_DIR/context7-api.py" resolve "$LIBRARY_NAME" 2>&1)

  # Extract first library ID
  LIBRARY_ID=$(echo "$RESOLVE_OUTPUT" | grep -oP 'ID:\s*\K[/\w.-]+' | head -n 1)

  if [ -z "$LIBRARY_ID" ]; then
    echo "Error: Could not resolve library: $LIBRARY_NAME" >&2
    echo "$RESOLVE_OUTPUT" >&2
    exit 1
  fi

  [ $VERBOSE -eq 1 ] && echo "Resolved to: $LIBRARY_ID" >&2
fi

# Validate library ID
if [ -z "$LIBRARY_ID" ]; then
  echo "Error: Must specify --library-id or --library" >&2
  usage
fi

# Step 1: Fetch raw documentation using HTTP API (stays in shell memory!)
[ $VERBOSE -eq 1 ] && echo "Fetching documentation..." >&2

RAW_TEXT=$(python3 "$SCRIPT_DIR/context7-api.py" query "$LIBRARY_ID" "$TOPIC" --tokens "$TOKENS" --mode full 2>/dev/null)

if [ -z "$RAW_TEXT" ] || [ "$RAW_TEXT" = "null" ]; then
  echo "Error: No documentation received from Context7" >&2
  exit 1
fi

# Calculate raw token count (approximate: words * 1.3)
if [ $VERBOSE -eq 1 ]; then
  RAW_WORDS=$(echo "$RAW_TEXT" | wc -w)
  RAW_TOKENS=$((RAW_WORDS * 13 / 10))
  echo "Raw response: ~$RAW_WORDS words (~$RAW_TOKENS tokens)" >&2
fi

# Step 2: Filter using shell tools (0 LLM tokens!)
# This is where the magic happens - all processing stays in shell

OUTPUT=""

if [ "$MODE" = "code" ]; then
  # Code mode: Extract code examples and API signatures

  # Extract code blocks
  CODE_BLOCKS=$(echo "$RAW_TEXT" | "$SCRIPT_DIR/extract-code-blocks.sh" 5)

  if [ -n "$CODE_BLOCKS" ] && [ "$CODE_BLOCKS" != "# No code blocks found" ]; then
    OUTPUT+="## Code Examples\n\n$CODE_BLOCKS\n"
  fi

  # Extract API signatures
  SIGNATURES=$(echo "$RAW_TEXT" | "$SCRIPT_DIR/extract-signatures.sh" 3)

  if [ -n "$SIGNATURES" ]; then
    OUTPUT+="\n## API Signatures\n\n$SIGNATURES\n"
  fi

else
  # Info mode: Extract conceptual content

  # Get fewer code examples (2 max)
  CODE_BLOCKS=$(echo "$RAW_TEXT" | "$SCRIPT_DIR/extract-code-blocks.sh" 2)

  if [ -n "$CODE_BLOCKS" ] && [ "$CODE_BLOCKS" != "# No code blocks found" ]; then
    OUTPUT+="## Examples\n\n$CODE_BLOCKS\n"
  fi

  # Extract key paragraphs (first 3 substantial paragraphs)
  OVERVIEW=$(echo "$RAW_TEXT" | \
    awk 'BEGIN{RS=""; FS="\n"} length($0) > 200 && !/```/{print; if(++count>=3) exit}')

  if [ -n "$OVERVIEW" ]; then
    OUTPUT+="\n## Overview\n\n$OVERVIEW\n"
  fi
fi

# Always add important notes
NOTES=$(echo "$RAW_TEXT" | "$SCRIPT_DIR/extract-notes.sh" 3)

if [ -n "$NOTES" ]; then
  OUTPUT+="\n## Important Notes\n\n$NOTES\n"
fi

# Fallback if no content extracted
if [ -z "$OUTPUT" ]; then
  OUTPUT=$(echo "$RAW_TEXT" | head -c 500)
  OUTPUT+="\n\n[Response truncated for brevity...]"
fi

# Step 3: Output filtered content (this is what enters Claude's context!)
echo -e "$OUTPUT"

# Calculate filtered token count and savings
if [ $VERBOSE -eq 1 ]; then
  FILTERED_WORDS=$(echo -e "$OUTPUT" | wc -w)
  FILTERED_TOKENS=$((FILTERED_WORDS * 13 / 10))

  if [ $RAW_TOKENS -gt 0 ]; then
    SAVINGS=$(( (RAW_TOKENS - FILTERED_TOKENS) * 100 / RAW_TOKENS ))
  else
    SAVINGS=0
  fi

  echo "" >&2
  echo "Filtered output: ~$FILTERED_WORDS words (~$FILTERED_TOKENS tokens)" >&2
  echo "Token savings: ${SAVINGS}%" >&2
fi
