#!/bin/bash
# Fetch raw documentation from Context7 MCP
# Output: JSON response (stays in shell, doesn't enter Claude context)
# Errors: Returns structured error messages for Claude to handle

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load helpers
source "$SCRIPT_DIR/load-api-key.sh"

# Detect Python command
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

LIBRARY_ID="${1:?Error: Library ID required}"
TOPIC="${2:-documentation}"
MODE="${3:-code}"
PAGE="${4:-1}"

# Build MCP command with API key (if available)
MCP_CMD=$(build_mcp_command)

# Build parameters JSON for query-docs (new API)
# Required: libraryId and query
PARAMS=$(cat <<JSON
{
  "libraryId": "$LIBRARY_ID",
  "query": "$TOPIC"
}
JSON
)

# Call MCP server and capture both stdout and stderr
OUTPUT=$("$PYTHON_CMD" "$SCRIPT_DIR/mcp-client.py" call \
  -s "$MCP_CMD" \
  -t query-docs \
  -p "$PARAMS" 2>&1) || {
  EXIT_CODE=$?

  # Check for common error patterns
  if [[ "$OUTPUT" == *"rate limit"* ]] || [[ "$OUTPUT" == *"429"* ]] || [[ "$OUTPUT" == *"Too many requests"* ]]; then
    echo "[RATE_LIMIT_ERROR]"
    echo ""
    echo "Context7 rate limit exceeded."
    if ! has_api_key; then
      echo ""
      api_key_error_message
    else
      echo "Your API key may have exceeded its quota. Check: https://context7.com/dashboard"
    fi
    exit 1
  fi

  # Check for API key / auth errors
  if [[ "$OUTPUT" == *"unauthorized"* ]] || [[ "$OUTPUT" == *"Unauthorized"* ]] || [[ "$OUTPUT" == *"API key"* ]] || [[ "$OUTPUT" == *"authentication"* ]]; then
    echo "[AUTH_ERROR]"
    echo ""
    echo "Authentication failed with Context7."
    if ! has_api_key; then
      api_key_error_message
    else
      echo "Your API key may be invalid. Get a new one at: https://context7.com/dashboard"
    fi
    exit 1
  fi

  # Check if no API key and got an error
  if ! has_api_key; then
    echo "[CONTEXT7_ERROR]"
    echo ""
    echo "Request failed. This may be due to missing API key."
    echo ""
    api_key_error_message
    echo ""
    echo "Original error: $OUTPUT"
    exit 1
  fi

  # Generic error
  echo "[FETCH_ERROR]"
  echo ""
  echo "Failed to fetch documentation from Context7."
  echo ""
  echo "Error details: $OUTPUT"
  echo "Exit code: $EXIT_CODE"
  exit 1
}

# Success - output the JSON
echo "$OUTPUT"
