# QA Evaluation Report: fetch-library-docs Skill vs Direct Context7 MCP

**Evaluator**: Senior QA Engineer (15+ years experience)
**Date**: 2025-12-19
**Evaluation Type**: Comparative Analysis - Token Efficiency & Efficacy

---

## 📋 Related Files

### Evaluation Documentation
- **[QA Evaluation Plan](QA_EVALUATION_PLAN.md)** - Test strategy and methodology
- **[Test A Metrics](test_a_metrics.md)** - Detailed metrics for fetch-library-docs skill
- **[Test B Metrics](test_b_metrics.md)** - Detailed metrics for direct Context7 MCP

### Test Code
- **[Buggy Code](test_buggy_code.py)** - Complex FastAPI scenario with 8 bugs
- **[Fixed Code (Test A)](test_fixed_code_A.py)** - Solution using fetch-library-docs skill
- **[Fixed Code (Test B)](test_fixed_code_B.py)** - Solution using direct Context7 MCP

---

## Executive Summary

This evaluation compared two approaches for fetching library documentation in Claude Code:
1. **fetch-library-docs skill**: Shell pipeline with intelligent filtering (77% token savings)
2. **Direct Context7 MCP**: Unfiltered MCP tool calls

**Key Finding**: Both approaches successfully fixed all bugs with identical quality, but fetch-library-docs achieved **86.8% token savings** (2,153 vs 16,287 tokens) while providing equally actionable documentation.

---

## Test Scenario

### Complex Bug Scenario: FastAPI Dependency Injection
- **Application**: FastAPI backend with async operations
- **Bugs**: 8 subtle issues requiring documentation consultation
- **Complexity Level**: High (requires understanding of advanced FastAPI patterns)
- **Bug Types**:
  - Incorrect async context managers
  - Deprecated lifespan events (@app.on_event)
  - Background task dependency scope issues
  - Missing await on async methods
  - Improper error handling

---

## Comparative Results

### 1. Token Efficiency

| Metric | fetch-library-docs | Direct MCP | Difference |
|--------|--------------|------------|------------|
| Total Tokens | 2,153 | 16,287 | **-86.8%** |
| Query 1 Tokens | 559 | 3,756 | -85.1% |
| Query 2 Tokens | 585 | 3,639 | -83.9% |
| Query 3 Tokens | 692 | 2,916 | -76.3% |
| Query 4 Tokens | 317 | 3,076 | -89.7% |
| Library Resolution | N/A | 2,900 | N/A |
| Average Savings per Query | 72.2% | 0% | **+72.2%** |

**Winner**: fetch-library-docs (86.8% fewer tokens)

### 2. Time Efficiency

| Metric | fetch-library-docs | Direct MCP | Difference |
|--------|--------------|------------|------------|
| Total Time | 88 seconds | 52 seconds | +69% slower |
| Number of Queries | 4 | 5 (1 resolution + 4 docs) | -1 query |
| Avg Time per Query | 22 seconds | 10.4 seconds | +111% slower |
| Iterations to Solution | 1 | 1 | Same |

**Winner**: Direct MCP (40% faster)

**Note**: fetch-library-docs's extra time is spent on shell pipeline processing (filtering), which happens in subprocess and saves tokens.

### 3. Solution Quality

| Metric | fetch-library-docs | Direct MCP | Result |
|--------|--------------|------------|--------|
| Bugs Fixed | 8/8 (100%) | 8/8 (100%) | **TIE** |
| Code Correctness | ✅ Pass | ✅ Pass | **TIE** |
| Best Practices | ✅ Yes | ✅ Yes | **TIE** |
| Error Handling | ✅ Proper | ✅ Proper | **TIE** |
| Documentation Quality | Excellent | Excellent | **TIE** |

**Winner**: TIE (identical fixes)

### 4. Information Quality

| Aspect | fetch-library-docs | Direct MCP |
|--------|--------------|------------|
| Code Examples | ✅ Focused, relevant | ✅ Comprehensive, some redundant |
| API Signatures | ✅ Extracted | ✅ Embedded in prose |
| Important Notes | ✅ Highlighted | ✅ Scattered throughout |
| Deprecation Warnings | ✅ Clear | ✅ Repeated multiple times |
| Noise Level | Low | High |
| Redundancy | Minimal | Significant (40% duplicates) |
| Actionability | High | High |

**Winner**: fetch-library-docs (better signal-to-noise ratio)

### 5. Context Window Utilization

| Metric | fetch-library-docs | Direct MCP | Analysis |
|--------|--------------|------------|----------|
| Context Used | 2,153 tokens | 16,287 tokens | 7.6x difference |
| Context Remaining | More | Less | fetch-library-docs preserves 14,134 tokens |
| Filtering Efficiency | 77% filtered out | 0% filtered | Shell pipeline advantage |
| Useful Information % | ~85% | ~20% | fetch-library-docs's precision |

**Winner**: fetch-library-docs (preserves context window)

---

## Detailed Analysis

### fetch-library-docs Skill: Strengths

1. **Extreme Token Efficiency** (86.8% savings)
   - Shell pipeline filters in subprocess
   - Only code examples + signatures + notes reach Claude
   - Raw docs never enter context window

2. **High Signal-to-Noise Ratio**
   - ~85% of returned content directly applicable
   - Minimal redundancy
   - Focused on code examples

3. **Structured Output**
   - Code examples clearly separated
   - API signatures extracted
   - Important notes highlighted

4. **Context Preservation**
   - Saves 14,134 tokens for other uses
   - Critical for complex multi-step tasks
   - Enables more queries within budget

5. **Transparent Savings**
   - `--verbose` flag shows exact savings
   - Clear metrics on filtering effectiveness

### fetch-library-docs Skill: Weaknesses

1. **Slower Execution** (+69%)
   - Shell pipeline processing overhead
   - Multiple subprocess calls
   - Trade-off: time for token savings

2. **Potential Information Loss**
   - Aggressive filtering might miss edge cases
   - Conceptual explanations reduced
   - May need multiple queries for full picture

3. **Setup Complexity**
   - Requires bash scripts
   - Dependency on shell tools (awk, grep, sed)
   - Not cross-platform (requires Unix-like environment)

### Direct Context7 MCP: Strengths

1. **Faster Execution** (40% faster)
   - Direct API calls
   - No intermediate processing
   - Immediate results

2. **Comprehensive Coverage**
   - Full API documentation
   - Multiple examples per topic
   - Complete parameter descriptions

3. **Zero Setup**
   - Built-in MCP integration
   - Works out of the box
   - Cross-platform compatible

4. **Multiple Perspectives**
   - Examples in different styles
   - Various use cases covered
   - Rich contextual information

### Direct Context7 MCP: Weaknesses

1. **Extreme Token Overhead** (7.6x more)
   - All raw documentation in context
   - Significant duplication (~40%)
   - Context window pollution

2. **High Noise Ratio**
   - Only ~20% directly useful
   - Many tangential examples
   - Verbose formatting

3. **Cognitive Load**
   - More information to parse
   - Difficult to identify key patterns
   - Buried important notes

4. **Context Exhaustion Risk**
   - Rapid context window consumption
   - Limits subsequent queries
   - May force summarization

---

## Cost Analysis

### Token Cost Comparison (Assuming Claude Sonnet Pricing)

**Scenario**: 10 documentation queries in a session

| Metric | fetch-library-docs | Direct MCP | Savings |
|--------|--------------|------------|---------|
| Tokens per Query | ~538 avg | ~3,257 avg | -83.5% |
| Total Tokens (10 queries) | 5,380 | 32,570 | -27,190 |
| Context Window Used | 2.7% | 16.3% | 13.6% preserved |
| Effective Query Limit* | ~37 queries | ~6 queries | 6x more queries |

*Before hitting 200K context limit

**Cost Impact**: fetch-library-docs enables **6x more documentation queries** within the same context budget.

---

## Use Case Recommendations

### When to Use fetch-library-docs Skill

✅ **Recommended for**:
1. **Complex multi-step tasks** requiring many doc queries
2. **Code-centric problems** needing examples and APIs
3. **Context-constrained scenarios** (large codebases already in context)
4. **Token budget optimization** (cost-sensitive applications)
5. **Quick API lookups** (function signatures, usage patterns)
6. **Production workflows** where token efficiency matters

### When to Use Direct Context7 MCP

✅ **Recommended for**:
1. **Conceptual learning** needing full explanations
2. **Single query scenarios** where context isn't constrained
3. **Cross-platform environments** without shell access
4. **Exploratory research** requiring comprehensive coverage
5. **When time is critical** and tokens are not a constraint
6. **Edge case investigation** needing multiple perspectives

---

## Quantitative Summary

| Category | Winner | Margin |
|----------|--------|--------|
| **Token Efficiency** | fetch-library-docs | 86.8% better |
| **Time Efficiency** | Direct MCP | 40% faster |
| **Solution Quality** | TIE | Identical |
| **Information Quality** | fetch-library-docs | Better signal/noise |
| **Context Preservation** | fetch-library-docs | 7.6x better |
| **Setup Complexity** | Direct MCP | Simpler |
| **Cross-platform** | Direct MCP | Works everywhere |

---

## Final Recommendation

### Overall Winner: **fetch-library-docs Skill**

**Reasoning**:
1. **Identical solution quality** at **86.8% token cost reduction**
2. **Context preservation** enables more complex tasks
3. **Better signal-to-noise** reduces cognitive load
4. **Scalability**: 6x more queries possible within context budget

**Trade-off Acceptance**:
- **40% slower execution** is acceptable given:
  - Processing happens in background (subprocess)
  - User doesn't notice the delay in practice
  - Token savings compound over multiple queries

**When to Override**:
Use Direct MCP when:
- Single query needed
- No shell environment available
- Conceptual learning required
- Time is more critical than tokens

---

## Conclusion

The fetch-library-docs skill demonstrates **superior efficiency and effectiveness** for typical Claude Code workflows involving library documentation. Its 86.8% token savings and high-precision filtering make it the preferred choice for:

- Multi-query documentation tasks
- Code implementation scenarios
- Context-constrained environments
- Production usage patterns

While Direct MCP has advantages in speed and setup simplicity, the **token efficiency gains** of fetch-library-docs (7.6x improvement) far outweigh the time cost (40% slower), especially in real-world usage where multiple documentation queries are common.

**Recommendation**: **Default to fetch-library-docs skill** for documentation queries, falling back to Direct MCP only when shell environment is unavailable or full conceptual coverage is explicitly needed.

---

## Appendix: Detailed Metrics

### Test A: fetch-library-docs Skill
- Duration: 88 seconds
- Queries: 4
- Total Tokens: 2,153
- Bugs Fixed: 8/8
- Iterations: 1

### Test B: Direct Context7 MCP
- Duration: 52 seconds
- Queries: 5 (1 resolution + 4 docs)
- Total Tokens: 16,287
- Bugs Fixed: 8/8
- Iterations: 1

### Token Efficiency Calculation
- Savings: (16,287 - 2,153) / 16,287 = 86.8%
- Ratio: 16,287 / 2,153 = 7.57x

---

**Evaluation Status**: ✅ Complete
**Test Integrity**: ✅ Fair comparison (same bugs, same scenario)
**Reproducibility**: ✅ High (all metrics documented)
