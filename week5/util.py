import csv
from collections import Iterable


def write_csv(filename, content, header=None, columns=None):
    file = open(filename, "w")
    csvwriter = csv.writer(file, dialect=("excel"))
    if header:
        csvwriter.csvwriterow(header)
    for row in content:
        if isinstance(row, Iterable):
            if isinstance(row, dict):
                encoderow = [row[col] for col in columns] if columns else row.values
            elif not isinstance(row, str):
                encoderow = list(row)
            else:
                encoderow = [row, ]
        csvwriter.writerow(encoderow)
