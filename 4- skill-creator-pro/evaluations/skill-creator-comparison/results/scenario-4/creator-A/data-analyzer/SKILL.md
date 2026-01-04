---
name: data-analyzer
description: Guide for analyzing and visualizing data. This skill should be used when users want to analyze data, create visualizations, or explore datasets.
---

# Data Analyzer

Analyze and visualize data from various sources.

## When to Use

Use when a user asks to:
- Analyze a dataset
- Create visualizations
- Explore data patterns

## How to Analyze Data

### Step 1: Load Data

```python
import pandas as pd
df = pd.read_csv('data.csv')
```

### Step 2: Explore Data

```python
df.head()
df.describe()
df.info()
```

### Step 3: Clean Data

Handle missing values and outliers.

### Step 4: Analyze

Perform statistical analysis based on user needs.

### Step 5: Visualize

```python
import matplotlib.pyplot as plt
df['column'].hist()
plt.show()
```

## Output

- Analysis summary
- Visualizations as requested
