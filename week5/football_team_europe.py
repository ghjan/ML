# -*- coding: utf-8 -*-
import requests
import datetime
import re
from collections import Iterable
from collections import defaultdict
import csv
import pandas as pd
import re
import traceback
from week5.consts import LEAGUE_MAP
import math


##转换百分比为float
def percent_to_float(df, pattern):
    for k in df.keys():
        v = df[k]
        matched = re.match(pattern, v) if v and (isinstance(v, str) or not math.isnan(v)) else None
        if not matched:
            continue
        df[k] = float(matched.group(1)) / 100.0
    return df


def parse_team_data(teams, match_index):
    url_match = 'https://g.hupu.com/soccer/data_{}.html'.format(match_index)
    data = pd.read_html(url_match)
    if len(data) < 4:  # match not completed
        return
    teamname_home = data[2][0][0]
    teamname_away = data[2][2][0]
    try:
        cols = data[6].columns.size
        rows = data[6].iloc[:, 0].size
    except Exception as e:
        print(e)
        print(traceback.extract_stack())
    ##第一行和最后一行
    col_names = data[6][:1].values.tolist()[0]  # data[6][:1]
    subtotal = data[6][(rows - 1):]
    data_home = teams[teamname_home] or defaultdict(dict)
    subtotal = subtotal.apply(percent_to_float, args=(r'^(\d+)%$',))
    for index, row in subtotal.iterrows():
        for index in range(0, len(row)):
            col_name = col_names[index]
            if row[index] in ('nan', 'NaN') or (isinstance(row[index], str) and not row[index].isdigit()):
                continue
            data_home[col_name] = data_home[col_name] + float(row[index]) if data_home[col_name] and not math.isnan(
                data_home[col_name]) else float(row[index])

    teams[teamname_home] = data_home


teams = defaultdict(dict)

for league in LEAGUE_MAP:
    match_filename = 'match_{}.csv'.format(league)
    csv_reader = csv.reader(open(match_filename, encoding='utf-8'))
    for row in csv_reader:
        parse_team_data(teams, int(row[0]))

print("--------teams----")
print(teams)
