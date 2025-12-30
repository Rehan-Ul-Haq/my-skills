#!/usr/bin/env python3
"""
Context7 HTTP API Client

Token-efficient library documentation fetcher using Context7 REST API.
Replaces MCP-based approach with direct HTTP calls for simplicity.

Usage:
    python context7-api.py resolve <library-name>
    python context7-api.py query <library-id> <topic> [--tokens N]
    python context7-api.py fetch <library-name> <topic> [--tokens N]

Environment:
    CONTEXT7_API_KEY - Required: Your Context7 API key
    CONTEXT7_API_URL - Optional: API base URL (default: https://context7.com/api/v2)

Examples:
    python context7-api.py resolve react
    python context7-api.py query /vercel/next.js routing
    python context7-api.py fetch prisma queries --tokens 3000
"""

import os
import sys
import json
import argparse
from urllib.request import Request, urlopen
from urllib.parse import urlencode, quote
from urllib.error import HTTPError, URLError


def get_api_key():
    """Get API key from environment."""
    key = os.environ.get('CONTEXT7_API_KEY')
    if not key:
        # Try loading from .env file
        env_file = os.path.join(os.path.dirname(__file__), '..', '.env')
        if os.path.exists(env_file):
            with open(env_file) as f:
                for line in f:
                    line = line.strip()
                    if line.startswith('CONTEXT7_API_KEY=') and not line.startswith('#'):
                        key = line.split('=', 1)[1].strip().strip('"\'')
                        break
    if not key or key == 'your_api_key_here':
        print("Error: CONTEXT7_API_KEY not set", file=sys.stderr)
        print("Get your API key at: https://context7.com/dashboard", file=sys.stderr)
        sys.exit(1)
    return key


def get_api_url():
    """Get API base URL."""
    return os.environ.get('CONTEXT7_API_URL', 'https://context7.com/api/v2')


def make_request(endpoint, params=None):
    """Make authenticated API request."""
    api_key = get_api_key()
    base_url = get_api_url()

    url = f"{base_url}{endpoint}"
    if params:
        url += '?' + urlencode(params)

    headers = {
        'Authorization': f'Bearer {api_key}',
        'Accept': 'application/json',
        'User-Agent': 'Context7-Efficient-Skill/1.0'
    }

    try:
        req = Request(url, headers=headers)
        with urlopen(req, timeout=30) as response:
            return json.loads(response.read().decode('utf-8'))
    except HTTPError as e:
        if e.code == 401:
            print("Error: Invalid API key", file=sys.stderr)
        elif e.code == 404:
            print(f"Error: Resource not found: {endpoint}", file=sys.stderr)
        elif e.code == 429:
            print("Error: Rate limit exceeded. Please wait and try again.", file=sys.stderr)
        else:
            print(f"Error: HTTP {e.code}: {e.reason}", file=sys.stderr)
        sys.exit(1)
    except URLError as e:
        print(f"Error: Network error: {e.reason}", file=sys.stderr)
        sys.exit(1)
    except json.JSONDecodeError:
        print("Error: Invalid JSON response", file=sys.stderr)
        sys.exit(1)


def resolve_library(library_name):
    """
    Resolve library name to Context7 library ID.

    Args:
        library_name: Library name (e.g., "react", "nextjs")

    Returns:
        dict with library info including ID
    """
    params = {
        'query': library_name,
        'limit': 5
    }

    result = make_request('/libraries/search', params)

    if not result or not result.get('libraries'):
        print(f"No libraries found for: {library_name}", file=sys.stderr)
        sys.exit(1)

    return result['libraries']


def query_docs(library_id, topic, tokens=5000):
    """
    Query documentation for a specific library and topic.

    Args:
        library_id: Context7 library ID (e.g., "/vercel/next.js")
        topic: Topic to query (e.g., "routing")
        tokens: Maximum tokens in response

    Returns:
        Documentation content
    """
    # Clean library ID
    library_id = library_id.lstrip('/')

    params = {
        'topic': topic,
        'tokens': tokens
    }

    endpoint = f'/docs/code/{library_id}'
    result = make_request(endpoint, params)

    return result


def fetch_docs(library_name, topic, tokens=5000):
    """
    Resolve library and fetch documentation in one step.

    Args:
        library_name: Library name (e.g., "react")
        topic: Topic to query
        tokens: Maximum tokens

    Returns:
        Documentation content
    """
    # First resolve the library
    libraries = resolve_library(library_name)

    if not libraries:
        print(f"Library not found: {library_name}", file=sys.stderr)
        sys.exit(1)

    # Use the first (best) match
    library = libraries[0]
    library_id = library.get('id', '').lstrip('/')

    if not library_id:
        print("Error: No library ID in response", file=sys.stderr)
        sys.exit(1)

    # Debug info
    print(f"# Resolved: {library_name} -> /{library_id}", file=sys.stderr)
    print(f"# Name: {library.get('name', 'Unknown')}", file=sys.stderr)
    print(f"# Snippets: {library.get('snippets', 'N/A')}", file=sys.stderr)
    print("---", file=sys.stderr)

    # Query the documentation
    return query_docs(library_id, topic, tokens)


def extract_code_blocks(content):
    """Extract code blocks from documentation."""
    if isinstance(content, dict):
        content = json.dumps(content, indent=2)

    blocks = []
    in_block = False
    current_block = []
    lang = ''

    for line in content.split('\n'):
        if line.startswith('```'):
            if in_block:
                blocks.append({'lang': lang, 'code': '\n'.join(current_block)})
                current_block = []
                in_block = False
            else:
                lang = line[3:].strip()
                in_block = True
        elif in_block:
            current_block.append(line)

    return blocks


def format_output(result, mode='full'):
    """Format output based on mode."""
    if mode == 'json':
        return json.dumps(result, indent=2)

    if mode == 'code':
        # Extract only code blocks
        content = json.dumps(result, indent=2) if isinstance(result, dict) else str(result)
        blocks = extract_code_blocks(content)
        output = []
        for block in blocks:
            if block['lang']:
                output.append(f"```{block['lang']}")
            else:
                output.append("```")
            output.append(block['code'])
            output.append("```\n")
        return '\n'.join(output) if output else content

    # Full mode - return formatted JSON or content
    if isinstance(result, dict):
        # Extract documentation content if present
        if 'content' in result:
            return result['content']
        if 'documentation' in result:
            return result['documentation']
        return json.dumps(result, indent=2)

    return str(result)


def main():
    parser = argparse.ArgumentParser(
        description='Context7 HTTP API Client - Token-efficient documentation fetcher',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s resolve react
  %(prog)s query /vercel/next.js routing
  %(prog)s fetch prisma queries --tokens 3000
  %(prog)s fetch react hooks --mode code

Environment Variables:
  CONTEXT7_API_KEY  Your Context7 API key (required)
  CONTEXT7_API_URL  API base URL (optional)
        """
    )

    subparsers = parser.add_subparsers(dest='command', help='Command to run')

    # Resolve command
    resolve_parser = subparsers.add_parser('resolve', help='Resolve library name to ID')
    resolve_parser.add_argument('library', help='Library name to resolve')

    # Query command
    query_parser = subparsers.add_parser('query', help='Query docs by library ID')
    query_parser.add_argument('library_id', help='Context7 library ID (e.g., /vercel/next.js)')
    query_parser.add_argument('topic', help='Topic to query')
    query_parser.add_argument('--tokens', type=int, default=5000, help='Max tokens (default: 5000)')
    query_parser.add_argument('--mode', choices=['full', 'code', 'json'], default='full', help='Output mode')

    # Fetch command (resolve + query)
    fetch_parser = subparsers.add_parser('fetch', help='Resolve library and fetch docs')
    fetch_parser.add_argument('library', help='Library name')
    fetch_parser.add_argument('topic', help='Topic to query')
    fetch_parser.add_argument('--tokens', type=int, default=5000, help='Max tokens (default: 5000)')
    fetch_parser.add_argument('--mode', choices=['full', 'code', 'json'], default='full', help='Output mode')

    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        sys.exit(1)

    if args.command == 'resolve':
        libraries = resolve_library(args.library)
        for lib in libraries:
            print(f"ID: {lib.get('id', 'N/A')}")
            print(f"Name: {lib.get('name', 'Unknown')}")
            print(f"Description: {lib.get('description', 'N/A')[:100]}...")
            print(f"Snippets: {lib.get('snippets', 'N/A')}")
            print("---")

    elif args.command == 'query':
        result = query_docs(args.library_id, args.topic, args.tokens)
        print(format_output(result, args.mode))

    elif args.command == 'fetch':
        result = fetch_docs(args.library, args.topic, args.tokens)
        print(format_output(result, args.mode))


if __name__ == '__main__':
    main()
