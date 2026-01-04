# csvtool

A CLI tool for processing CSV files with filtering, sorting, and statistics.

## Installation

```bash
pip install csvtool
```

Or install from source:

```bash
git clone https://github.com/user/csvtool
cd csvtool
pip install -e .
```

## Usage

```bash
csvtool <command> <input.csv> [options]
```

## Commands

### filter

Filter rows where a column matches a value.

```bash
csvtool filter data.csv --column status --value active
csvtool filter data.csv -c status -v active -o filtered.csv
```

### sort

Sort rows by a specified column.

```bash
csvtool sort data.csv --column name
csvtool sort data.csv -c price --reverse
```

### stats

Display basic statistics about the CSV file.

```bash
csvtool stats data.csv
# Output:
# Rows: 150
# Columns: id, name, status, price
```

## Examples

### Processing sales data

```bash
# Filter active products
csvtool filter products.csv -c status -v active -o active_products.csv

# Sort by price descending
csvtool sort active_products.csv -c price --reverse

# Get overview
csvtool stats products.csv
```

## Requirements

- Python 3.8+

## License

MIT
