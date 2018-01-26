import csv
from collections import Iterable
import math


def write_csv(filename, content, header=None, columns=None):
    file = open(filename, "w", newline='')
    csvwriter = csv.writer(file, dialect=("excel"))
    if header:
        csvwriter.writerow(header)
    for row in content:
        if isinstance(row, Iterable):
            if isinstance(row, dict):
                encoderow = [row[col] for col in columns] if columns else row.values
            elif not isinstance(row, str):
                encoderow = list(row)
            else:
                encoderow = [row, ]
        csvwriter.writerow(encoderow)


def write_dict2csv(filename, content, header=None, columns=None):
    file = open(filename, "w", newline='')
    csvwriter = csv.writer(file, dialect=("excel"))
    if header:
        csvwriter.writerow(header)
    if isinstance(content, dict):
        for row_name, row in content.items():
            if not row:
                continue
            if isinstance(row, Iterable):
                if isinstance(row, dict):
                    encoderow = [row[col] for col in columns] if columns else row.values()
                elif not isinstance(row, str):
                    encoderow = list(row)
            else:
                encoderow = [row, ]
            encoderow.insert(0, row_name)
            csvwriter.writerow(encoderow)
