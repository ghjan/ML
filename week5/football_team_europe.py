# -*- coding: utf-8 -*-
import requests
import datetime
import re
from collections import Iterable
from collections import defaultdict
import csv
import pandas as pd
import re


def percent_to_float(df, pattern):
    for index in range(0, len(df)):
        matched = df[index] and isinstance(df[index], str) and re.match(pattern, str(df[index]))
        if not matched:
            continue
        df[index] = float(matched.group(1)) / 100.0
    return df


i = 10854899
url_match = 'https://g.hupu.com/soccer/data_{}.html'.format(i)

data = pd.read_html(url_match)

LEAGUE_MAP = {
    'england': 2,
    'spain': 3,
    'italy': 4,
    'germany': 5,
    'france': 6,
}
# print(data)

teams = defaultdict(dict)
teamname_home = data[2][0][0]
teamname_away = data[2][2][0]
cols = data[6].columns.size
rows = data[6].iloc[:, 0].size
##第一行和最后一行
col_names = data[6].columns.values.tolist()  # data[6][:1]
print("-------type(col_names:{}".format(type(col_names)))
subtotal = data[6][(rows - 1):]
print("-------type(subtotal:{}".format(type(subtotal)))

print("-------subtotal:{}".format(subtotal))

data_home = teams[teamname_home] or defaultdict(dict)
subtotal = subtotal.apply(percent_to_float, args=(r'^(\d+)%$',))
print("subtotal:{}".format(subtotal))
# for index, row in subtotal.iterrows():
#     for index in range(0, len(row)):
#         col_name = col_names[index][0]
#         if row[index] == 'NAN' or (isinstance(row[index], str) and not row[index].isdigit()):
#             continue
#         data_home[col_name] = data_home[col_name] + float(row[index]) if data_home[col_name] else float(row[index])
# print("--------data_home----")
# print(data_home)
##转换百分比为float
