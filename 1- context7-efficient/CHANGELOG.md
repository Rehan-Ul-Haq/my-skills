# Changelog

All notable changes to the `fetch-library-docs` skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.1] - 2026-01-01

### Added
- **Auto-fallback for empty results**: When content-type filtering returns empty, skill automatically retries with `--content-type all`
  - No extra API calls used (fallback uses cached raw response)
  - Verbose mode shows: `[INFO] No content found for 'X', auto-retrying with 'all'...`
  - Prevents false negatives when library docs don't match expected structure (e.g., Prisma troubleshooting)

### Fixed
- Prisma and similar libraries now return results even when content-type filters don't match their doc structure

---

## [2.0.0] - 2026-01-01

### Added
- **Auto-invocation**: Skill now auto-triggers based on context detection (implementing, debugging, installing, integrating, upgrading, uncertain)
- **Content-type filtering**: New `--content-type` parameter with 8 types: `examples`, `api-ref`, `setup`, `concepts`, `migration`, `troubleshooting`, `patterns`, `all`
- **Multi-type support**: Combine content types with commas (e.g., `--content-type examples,api-ref`)
- **`--max-items` parameter**: Control maximum items per content type (default: 5)
- **Call budget awareness**: Respects Context7's 3-call limit per question
- **Library validation**: Detects mismatches when resolved library doesn't match requested name
- **Library ID format validation**: Catches invalid `--library-id` format before wasting API calls
- **Exponential backoff**: Auto-retries infrastructure failures (2s, 5s, 10s delays)
- **New filter scripts**:
  - `filter-by-type.sh` - Content-type router
  - `extract-apidoc.sh` - APIDOC block extractor
  - `extract-terminal-blocks.sh` - Terminal/bash command extractor
  - `extract-prose.sh` - Conceptual content extractor
  - `extract-migration.sh` - Before/after and upgrade extractor
  - `extract-troubleshooting.sh` - Debugging and workaround extractor
  - `extract-patterns.sh` - Best practice extractor
- **Progressive disclosure**: SKILL.md restructured (~110 lines) with reference files:
  - `references/library-ids.md` - Complete library ID list
  - `references/patterns.md` - Usage patterns
  - `references/context7-tools.md` - API details, errors, setup

### Changed
- **BREAKING**: Token savings now reported as range (60-90%) instead of fixed percentage
- **BREAKING**: `--mode` parameter deprecated (use `--content-type` instead)
- **BREAKING**: `--page` parameter removed (not supported by Context7 API)
- **Decision logic**: Changed from prompt-based to context-based auto-detection
- **SKILL.md structure**: Reorganized with auto-detection triggers, decision logic, and references
- **Error messages**: Now include call budget status (e.g., "1 of 3 calls used")

### Fixed
- False positive library resolution (e.g., "nonexistent-xyz" resolving to random library)
- Silent failure on invalid library ID format
- Legacy `--mode` incorrectly overriding explicit `--content-type`

### Removed
- Interactive prompts ("Did you mean...?") - skill now returns structured errors for Claude to handle

---

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

---

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

### From v1.x to v2.0.0

1. **Update content-type usage** (if using `--mode`):
   ```bash
   # Old (deprecated)
   --mode code
   --mode info

   # New
   --content-type examples,api-ref
   --content-type concepts,examples
   ```

2. **Update token savings expectations**:
   - Old: Fixed ~77% or ~86.8%
   - New: 60-90% depending on content type

3. **Leverage auto-invocation**:
   - Skill now auto-triggers during implementation, debugging, installing
   - No need to explicitly ask for docs

4. **Use `--library-id` to save API calls**:
   ```bash
   # Saves 1 API call (Context7 has 3-call limit)
   --library-id /reactjs/react.dev
   ```

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

### API Key Setup (Required since v1.0.0)

Context7 requires an API key. Get one free at [context7.com/dashboard](https://context7.com/dashboard).

```bash
echo "CONTEXT7_API_KEY=ctx7sk_your_key_here" > ~/.context7.env
```
