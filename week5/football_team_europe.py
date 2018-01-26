# -*- coding: utf-8 -*-
from collections import defaultdict
import csv
import pandas as pd
import re
import math
import copy
import traceback
from week5.consts import LEAGUE_MAP
from week5.util import write_csv, write_dict2csv


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
    try:
        data = pd.read_html(url_match)
    except Exception as e:
        print(e)
        print(traceback.format_exc())
        return None, None, None
    if len(data) < 4:  # match not completed
        return None, None, None
    teamname_home = data[2][0][0]
    teamname_away = data[2][2][0]
    teams['home'][teamname_home], col_names = _parse_team_total(data, teams, teamname_home, 6)
    teams['away'][teamname_away], _ = _parse_team_total(data, teams, teamname_away, 7)
    return col_names, teamname_home, teamname_away


def _parse_team_total(data, teams, teamname, index):
    # cols = data[index].columns.size
    rows = data[index].iloc[:, 0].size
    ##第一行和最后一行
    col_names = data[index][:1].values.tolist()[0]
    subtotal = data[index][(rows - 1):]
    team_data = _parse_team_data(teams, teamname, col_names, subtotal)
    return team_data, col_names


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


def _process_team_data(teams, league):
    match_filename = 'match_{}.csv'.format(league)
    csv_reader = csv.reader(open(match_filename, encoding='utf-8'))
    matches = [int(row[0]) for row in csv_reader if row or row[0] and not math.isnan(row[0])]
    _test(teams, league, matches=matches)


def _test(teams, league='germany', matches=[10854899, 10854948, 10854911, 10855058, 10855063]):
    for index in matches:
        if not index or not index or math.isnan(index):
            continue
        col_names, _, _2 = _analyze_team_data(teams, int(index))
    # 数据写入csv文件
    if teams and league and col_names:
        _post_process(teams, league, col_names)


def _post_process(teams, league, col_names):
    # 数据写入csv文件
    headers = copy.copy(col_names)
    headers.insert(0, 'team')
    if teams['home']:
        _cal_team_data(teams['home'])
        write_dict2csv('teams_{}_home.csv'.format(league), teams['home'], header=headers, columns=col_names)
    if teams['away']:
        _cal_team_data(teams['away'])
        write_dict2csv('teams_{}_away.csv'.format(league), teams['away'], header=headers, columns=col_names)
    teams['subtotal'] = _cal_subtotal(teams['home'], teams['away'])
    if teams['subtotal']:
        _cal_team_data(teams['subtotal'])
        write_dict2csv('teams_{}_subtotal.csv'.format(league), teams['subtotal'], header=headers,
                       columns=col_names)


def _cal_team_data(team_data):
    for k in team_data.keys():
        v = teams['home'][k]
        if not v:
            continue
        if '射门' in v and v['射门'] > 0:
            v['射正率'] = 1.0 * v['射正'] / v['射门']


def _cal_subtotal(team_data1, team_data2):
    subtotal = defaultdict(dict)
    all_keys = set(list(team_data1.keys()))
    [all_keys.add(key) for key in team_data2.keys() if key]
    for k in all_keys:
        v1 = team_data1[k]
        v2 = team_data2[k]
        for k2 in v1.keys() or v2.keys():
            v21 = v1.get(k2)
            v22 = v2.get(k2)
            sum = v21 if v21 and not math.isnan(v21) else 0
            sum += v22 if v22 and not math.isnan(v22) else 0
            subtotal[k][k2] = sum
    return subtotal


if __name__ == '__main__':
    teams = {
        'home': defaultdict(dict),
        'away': defaultdict(dict),
        'subtotal': defaultdict(dict),
        'matches': defaultdict(dict),
    }
    for league in LEAGUE_MAP:
        if not league or league != 'germany':
            continue
        _process_team_data(teams, league)
        # _test(teams)
