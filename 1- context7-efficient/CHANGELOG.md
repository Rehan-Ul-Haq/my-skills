# Changelog

All notable changes to the `fetch-library-docs` skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-01

### Changed
- **BREAKING**: Renamed skill from `context7-efficient` to `fetch-library-docs` for better AI agent discoverability
- Updated to new Context7 MCP API (`query-docs` replaces `get-library-docs`)
- Improved skill description for clearer AI trigger recognition

### Added
- Cross-platform Python detection (Windows `python`, Linux/macOS `python3`, Windows `py -3`)
- Structured error messages for Claude Code integration (non-interactive mode)
- API key configuration via environment variable, project config, or user config
- `--api-status` flag to check API key configuration

### Fixed
- Windows compatibility issues with Python command detection
- Microsoft Store Python alias stub handling on Windows

### Removed
- Interactive setup wizard (incompatible with Claude Code's non-interactive execution)
- Deprecated `mode` and `page` parameters (removed from Context7 API)

## [0.1.0] - 2024-12-19

### Added
- Initial release as `context7-efficient`
- Shell pipeline architecture for token-efficient documentation fetching
- 77-86% token savings through intelligent filtering
- Code block extraction via `extract-code-blocks.sh`
- API signature extraction via `extract-signatures.sh`
- Important notes extraction via `extract-notes.sh`
- Universal MCP client (`mcp-client.py`)
- QA evaluation demonstrating 86.8% token savings

---

## Migration Guide

### From `context7-efficient` to `fetch-library-docs`

1. **Update skill folder name**:
   ```bash
   mv ~/.claude/skills/context7-efficient ~/.claude/skills/fetch-library-docs
   ```

2. **Update SKILL.md** (if customized):
   ```yaml
   name: fetch-library-docs  # was: context7-efficient
   ```

3. **No code changes required** - the shell scripts remain the same

### API Key Setup (New Requirement)

Context7 now requires an API key. Get one free at [context7.com/dashboard](https://context7.com/dashboard).

```bash
echo "CONTEXT7_API_KEY=ctx7sk_your_key_here" > ~/.context7.env
```
