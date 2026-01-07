---
name: data-analyzer
description: |
  Analyzes datasets to extract insights, identify patterns, and create visualizations.
  This skill should be used when users want to explore data, perform statistical analysis,
  identify trends, or visualize patterns in structured data.
---

# Data Analyzer

Extract insights from structured data through analysis and visualization.

## What This Skill Does

- Loads and validates data from various formats (CSV, JSON, Excel, SQL)
- Performs exploratory data analysis (EDA)
- Identifies patterns, correlations, outliers
- Creates appropriate visualizations
- Generates summary reports

## What This Skill Does NOT Do

- Machine learning / predictive modeling (use ML-specific tools)
- Real-time streaming analysis
- Big data processing (Spark, etc.)
- Data pipeline orchestration

---

## Before Implementation

| Source | Gather |
|--------|--------|
| **Codebase** | Existing data files, database connections |
| **Conversation** | Analysis goals, questions to answer |
| **Skill References** | Statistical methods from `references/` |

---

## Required Clarifications

| Clarification | Why |
|---------------|-----|
| Analysis goal | Exploration vs specific question vs report |
| Data format | CSV, database, API affects loading |
| Output format | Charts, tables, written report |
| Key questions | What insights are you looking for? |

---

## Analysis Workflow

```
1. Load → 2. Profile → 3. Clean → 4. Analyze → 5. Visualize → 6. Report
```

### 1. Load Data

Detect format, handle encoding, validate structure.

### 2. Profile Data

- Shape (rows, columns)
- Types (numeric, categorical, datetime)
- Missing values
- Unique counts

### 3. Clean Data

Based on findings:
- Handle missing: drop, fill, interpolate
- Fix types: dates, categories
- Remove duplicates

### 4. Analyze

| Analysis Type | When to Use |
|---------------|-------------|
| Descriptive stats | Summarize distributions |
| Correlation | Find relationships |
| Groupby aggregation | Compare segments |
| Time series | Temporal patterns |

### 5. Visualize

| Data Type | Visualization |
|-----------|---------------|
| Distribution | Histogram, box plot |
| Comparison | Bar chart, grouped bar |
| Relationship | Scatter, heatmap |
| Trend | Line chart |
| Composition | Pie, stacked bar |

### 6. Report

Summarize findings answering user's questions.

---

## Pre-Delivery Checklist

- [ ] Data loaded and validated
- [ ] Missing values addressed
- [ ] Analysis answers user's question
- [ ] Visualizations have titles and labels
- [ ] Insights clearly stated

---

## Reference Files

| File | Use When |
|------|----------|
| `references/statistical-methods.md` | Choosing analysis approach |
| `references/visualization-guide.md` | Selecting chart types |
