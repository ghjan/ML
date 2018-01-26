import csv
from collections import Iterable


def write_csv(filename, content, header=None):
    file = open(filename, "w")
    csvwriter = csv.writer(file, dialect=("excel"))
    if header:
        csvwriter.csvwriterow(header)
    for row in content:
        encoderow = list(row) if isinstance(row, Iterable) and not isinstance(row, str) else [row, ]
        csvwriter.writerow(encoderow)
