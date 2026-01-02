# csvtool

A CLI tool for processing CSV files.

## Installation

```bash
pip install csvtool
```

## Usage

```bash
csvtool <command> [options]
```

## Examples

### Filter rows

```python
csvtool filter data.csv --column status --value active
```

### Sort by column

```bash
csvtool sort data.csv --column name
```

### Show statistics

```bash
csvtool stats data.csv
```

## License

MIT License
