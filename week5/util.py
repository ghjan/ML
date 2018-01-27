import csv
from collections import Iterable


def write_csv(filename, content, header=None, columns=None):
    file = open(filename, "w", newline='')
    csv_writer = csv.writer(file)
    if header:
        csv_writer.writerow(header)
    for row in content:
        if isinstance(row, Iterable):
            if isinstance(row, dict):
                encode_row = [row[col] for col in columns] if columns else row.values
            elif not isinstance(row, str):
                encode_row = list(row)
            else:
                encode_row = [row, ]
        csv_writer.writerow(encode_row)


def write_dict2csv(filename, content, header=None, columns=None):
    file = open(filename, "w", newline='')
    csv_writer = csv.writer(file)
    if header:
        csv_writer.writerow(header)
    if isinstance(content, dict):
        for row_name, row in content.items():
            if not row:
                continue
            if isinstance(row, Iterable):
                if isinstance(row, dict):
                    encode_row = [row[col] for col in columns] if columns else row.values()
                elif not isinstance(row, str):
                    encode_row = list(row)
            else:
                encode_row = [row, ]
            encode_row.insert(0, row_name)
            csv_writer.writerow(encode_row)
