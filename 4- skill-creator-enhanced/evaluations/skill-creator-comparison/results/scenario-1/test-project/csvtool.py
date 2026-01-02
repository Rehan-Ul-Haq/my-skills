#!/usr/bin/env python3
"""
csvtool - A CLI tool for processing CSV files.

Commands:
    filter - Filter rows based on conditions
    sort - Sort by column
    stats - Show basic statistics
"""

import argparse
import csv
import sys
from pathlib import Path


def filter_csv(input_file: str, column: str, value: str, output: str = None):
    """Filter CSV rows where column matches value."""
    with open(input_file) as f:
        reader = csv.DictReader(f)
        rows = [row for row in reader if row.get(column) == value]

    out = open(output, 'w') if output else sys.stdout
    if rows:
        writer = csv.DictWriter(out, fieldnames=rows[0].keys())
        writer.writeheader()
        writer.writerows(rows)


def sort_csv(input_file: str, column: str, reverse: bool = False):
    """Sort CSV by specified column."""
    with open(input_file) as f:
        reader = csv.DictReader(f)
        rows = sorted(reader, key=lambda x: x.get(column, ''), reverse=reverse)

    if rows:
        writer = csv.DictWriter(sys.stdout, fieldnames=rows[0].keys())
        writer.writeheader()
        writer.writerows(rows)


def stats_csv(input_file: str):
    """Show basic statistics about CSV file."""
    with open(input_file) as f:
        reader = csv.DictReader(f)
        rows = list(reader)

    print(f"Rows: {len(rows)}")
    print(f"Columns: {', '.join(rows[0].keys()) if rows else 'N/A'}")


def main():
    parser = argparse.ArgumentParser(description='CSV processing tool')
    subparsers = parser.add_subparsers(dest='command')

    # Filter command
    filter_parser = subparsers.add_parser('filter', help='Filter rows')
    filter_parser.add_argument('input', help='Input CSV file')
    filter_parser.add_argument('--column', '-c', required=True)
    filter_parser.add_argument('--value', '-v', required=True)
    filter_parser.add_argument('--output', '-o', help='Output file')

    # Sort command
    sort_parser = subparsers.add_parser('sort', help='Sort by column')
    sort_parser.add_argument('input', help='Input CSV file')
    sort_parser.add_argument('--column', '-c', required=True)
    sort_parser.add_argument('--reverse', '-r', action='store_true')

    # Stats command
    stats_parser = subparsers.add_parser('stats', help='Show statistics')
    stats_parser.add_argument('input', help='Input CSV file')

    args = parser.parse_args()

    if args.command == 'filter':
        filter_csv(args.input, args.column, args.value, args.output)
    elif args.command == 'sort':
        sort_csv(args.input, args.column, args.reverse)
    elif args.command == 'stats':
        stats_csv(args.input)
    else:
        parser.print_help()


if __name__ == '__main__':
    main()
