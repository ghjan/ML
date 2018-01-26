# -*- coding: utf-8 -*-
from collections import defaultdict
import csv
import pandas as pd
import re
import math
from week5.consts import LEAGUE_MAP
from week5.util import write_csv


##转换百分比为float
def percent_to_float(df, pattern):
    for k in df.keys():
        v = df[k]
        matched = re.match(pattern, v) if v and (isinstance(v, str) or not math.isnan(v)) else None
        if not matched:
            continue
        df[k] = float(matched.group(1)) / 100.0
    return df


def _analyze_team_data(teams, match_index):
    url_match = 'https://g.hupu.com/soccer/data_{}.html'.format(match_index)
    data = pd.read_html(url_match)
    if len(data) < 4:  # match not completed
        return
    teamname_home = data[2][0][0]
    teamname_away = data[2][2][0]
    teams['home'][teamname_home] = _parse_team_total(data, teams, teamname_home, 6)
    teams['away'][teamname_away] = _parse_team_total(data, teams, teamname_away, 7)


def _parse_team_total(data, teams, teamname, index):
    # cols = data[index].columns.size
    rows = data[index].iloc[:, 0].size
    ##第一行和最后一行
    col_names = data[index][:1].values.tolist()[0]
    subtotal = data[index][(rows - 1):]
    team_data = _parse_team_data(teams, teamname, col_names, subtotal)
    return team_data


def _parse_team_data(teams, teamname_home, col_names, subtotal):
    data_home = teams['home'][teamname_home] or defaultdict(dict)
    subtotal = subtotal.apply(percent_to_float, args=(r'^(\d+)%$',))
    for index, row in subtotal.iterrows():
        for index in range(0, len(row)):
            col_name = col_names[index]
            if row[index] in ('nan', 'NaN') or (isinstance(row[index], str) and not row[index].isdigit()):
                continue
            data_home[col_name] = data_home[col_name] + float(row[index]) if data_home[col_name] and not math.isnan(
                data_home[col_name]) else float(row[index])
    return data_home


for league in LEAGUE_MAP:
    if league != 'germany':
        continue
    teams = {
        'home': defaultdict(dict),
        'away': defaultdict(dict),
        'subtotal': defaultdict(dict),
        'matches': defaultdict(dict),
    }
    match_filename = 'match_{}.csv'.format(league)
    csv_reader = csv.reader(open(match_filename, encoding='utf-8'))
    for row in csv_reader:
        _analyze_team_data(teams, int(row[0]))
    # 数据写入csv文件
    if teams['home']:
        write_csv('teams_{}_home.csv'.format(league), teams['home'])
    if teams['away']:
        write_csv('teams_{}_away.csv'.format(league), teams['away'])
    if teams['subtotal']:
        write_csv('teams_{}_subtotal.csv'.format(league), teams['subtotal'])
