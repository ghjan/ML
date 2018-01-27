# -*- coding: utf-8 -*-
from collections import defaultdict
import csv
import pandas as pd
import re
import math
import copy
import traceback
from week5.consts import LEAGUE_MAP
from week5.util import write_dict2csv


##转换百分比为float
def percent_to_float(df, pattern):
    for k in df.keys():
        v = df[k]
        matched = re.match(pattern, v) if v and (isinstance(v, str) or not math.isnan(v)) else None
        if not matched:
            continue
        df[k] = float(matched.group(1)) / 100.0
    return df


#
def find_date(info, pattern):
    matched = re.match(pattern, info) if info and isinstance(info, str)  else None
    if not matched:
        return None
    return matched.group(1)


# 控球率
def find_control_rate(info, pattern):
    matched = re.match(pattern, info) if info and isinstance(info, str)  else None
    if not matched:
        return None, None
    return 1.0 * int(matched.group(1)) / 100, 1.0 * int(matched.group(2)) / 100


# 角球
def find_cornerkick(info, pattern):
    matched = re.match(pattern, info) if info and isinstance(info, str)  else None
    if not matched:
        return None, None
    return int(matched.group(1)), int(matched.group(2))


def find_season_data(info, pattern):
    matched = re.match(pattern, info) if info and isinstance(info, str)  else None
    if not matched:
        return None, None
    return str(matched.group(1)), float(matched.group(2))


def _analyze_team_data(teams_data, match_index):
    url_match = 'https://g.hupu.com/soccer/data_{}.html'.format(match_index)
    try:
        data = pd.read_html(url_match)
    except Exception as e:
        print(e)
        print(traceback.format_exc())
        return None, None, None
    if len(data) < 4:  # match not completed
        return None, None, None
    team_name_home = data[2][0][0]
    team_name_away = data[2][2][0]
    pattern_date = '^.+\d+:\d+ (\d+\-\d+-\d+) .+'
    match_date = find_date(data[0][2][0], pattern_date)

    team_data_home = teams_data['home'][team_name_home] or defaultdict(dict)
    teams_data['home'][team_name_home], col_names = _parse_team_total(data, team_data_home, 6)
    teams_data['home'][team_name_home]['matches_count'] = 1 if not teams_data['home'][team_name_home][
        'matches_count'] else teams_data['home'][team_name_home]['matches_count'] + 1
    is_lasest_match_home = match_date > teams_data['home'][team_name_home][
        'lastest_match_date'] if teams_data['home'][team_name_home][
        'lastest_match_date'] else True
    teams_data['home'][team_name_home]['lastest_match_date'] = max(match_date, teams_data['home'][team_name_home][
        'lastest_match_date']) if teams_data['home'][team_name_home][
        'lastest_match_date'] else match_date

    team_data_away = teams_data['away'][team_name_away] or defaultdict(dict)
    teams_data['away'][team_name_away], _ = _parse_team_total(data, team_data_away, 7)
    teams_data['away'][team_name_away]['matches_count'] = 1 if not teams_data['away'][team_name_away][
        'matches_count'] else teams_data['away'][team_name_away]['matches_count'] + 1
    is_lasest_match_away = match_date > teams_data['away'][team_name_away][
        'lastest_match_date'] if teams_data['away'][team_name_away][
        'lastest_match_date'] else True
    teams_data['away'][team_name_away]['lastest_match_date'] = max(match_date, teams_data['away'][team_name_away][
        'lastest_match_date']) if teams_data['away'][team_name_away][
        'lastest_match_date'] else match_date

    pattern_season_data = '^(.+)：(\d+\.\d+)$'

    if is_lasest_match_home and len(data[4][1]):
        for index in range(0, len(data[4][1])):
            try:
                key, value = find_season_data(data[4][1][index], pattern_season_data)
                if key and value:
                    teams_data['home'][team_name_home][key] = value
            except Exception as e:
                print(e)
    if is_lasest_match_away and len(data[5][1]):
        for index in range(0, len(data[5][1])):
            key, value = find_season_data(data[5][1][index], pattern_season_data)
            if key and value:
                teams_data['away'][team_name_away][key] = value

    # 赛季平均控球率
    pattern_control_rate = '^(\d+)%(\d+)%$'
    control_rate_home, control_rate_away = find_control_rate(data[3][1][0], pattern_control_rate)
    teams_data['home'][team_name_home]['control_rate'] = control_rate_home if not teams_data['home'][team_name_home][
        'control_rate'] else (teams_data['home'][team_name_home]['control_rate'] * (
        teams_data['home'][team_name_home]['matches_count'] - 1) + control_rate_home) / \
                             teams_data['home'][team_name_home][
                                 'matches_count']

    teams_data['away'][team_name_away]['control_rate'] = control_rate_away if not teams_data['away'][team_name_away][
        'control_rate'] else (teams_data['away'][team_name_away]['control_rate'] * (
        teams_data['away'][team_name_away]['matches_count'] - 1) + control_rate_away) / \
                             teams_data['away'][team_name_away][
                                 'matches_count']

    # 角球
    pattern_cornerkick = '^(\d{1,2})(\d{1,2})$'
    cornerkick_home, cornerkick_away = find_cornerkick(data[3][1][4], pattern_cornerkick)
    teams_data['home'][team_name_home]['cornerkick'] = cornerkick_home + teams_data['home'][team_name_home][
        'cornerkick'] if teams_data['home'][team_name_home]['cornerkick'] else cornerkick_home
    teams_data['away'][team_name_away]['cornerkick'] = cornerkick_away + teams_data['away'][team_name_away][
        'cornerkick'] if teams_data['away'][team_name_away]['cornerkick'] else cornerkick_away
    col_names.extend(['matches_count', 'lastest_match_date', 'control_rate', 'cornerkick'])
    return col_names, team_name_home, team_name_away


def _parse_team_total(data, team_data, index):
    # cols = data[index].columns.size
    rows = data[index].iloc[:, 0].size
    ##第一行和最后一行
    col_names = data[index][:1].values.tolist()[0]
    subtotal = data[index][(rows - 1):]
    team_data = _parse_team_data(team_data, col_names, subtotal)
    return team_data, col_names


def _parse_team_data(team_data, col_names, subtotal):
    subtotal = subtotal.apply(percent_to_float, args=(r'^(\d+)%$',))
    for index, row in subtotal.iterrows():
        for col_index in range(0, len(row)):
            col_name = col_names[col_index]
            if row[col_index] in ('nan', 'NaN') or (isinstance(row[col_index], str) and not row[col_index].isdigit()):
                continue
            team_data[col_name] = team_data[col_name] + float(row[col_index]) if team_data[col_name] and not math.isnan(
                team_data[col_name]) else float(row[col_index])
    return team_data


def _process_team_data(teams_data, league_name):
    match_filename = 'match_{}.csv'.format(league_name)
    csv_reader = csv.reader(open(match_filename, encoding='utf-8'))
    matches = [int(row[0]) for row in csv_reader if row and row[0] and row[0].isdigit()]
    _test(teams_data, league_name, matches=set(matches))


def _test(teams_data, league_name='germany', matches=[10854899, 10854948, 10854911, 10855058, 10855063]):
    for index in matches:
        if not index or not index or math.isnan(index):
            continue
        col_names, _, _2 = _analyze_team_data(teams_data, int(index))
    # 数据写入csv文件
    if teams_data and league_name and col_names:
        _post_process(teams_data, league_name, col_names)


def _post_process(teams_data, league_name, col_names):
    # 数据写入csv文件
    headers = copy.copy(col_names)
    headers.insert(0, 'team')
    if teams_data['home']:
        _cal_team_data(teams_data['home'])
        write_dict2csv('teams_{}_home.csv'.format(league_name), teams_data['home'], header=headers, columns=col_names)
    if teams_data['away']:
        _cal_team_data(teams_data['away'])
        write_dict2csv('teams_{}_away.csv'.format(league_name), teams_data['away'], header=headers, columns=col_names)
    teams_data['subtotal'] = _cal_subtotal(teams_data['home'], teams_data['away'])
    if teams_data['subtotal']:
        _cal_team_data(teams_data['subtotal'])
        write_dict2csv('teams_{}_subtotal.csv'.format(league_name), teams_data['subtotal'], header=headers,
                       columns=col_names)


def _cal_team_data(team_data):
    for k in team_data.keys():
        v = teams['home'][k]
        if not v:
            continue
        if '射门' in v and v['射门'] > 0:
            v['射正率'] = 1.0 * v['射正'] / v['射门']


def _cal_subtotal(team_data1, team_data2, columns_average=('control_rate',), columns_max=('lastest_match_date',),
                  columns_str=('lastest_match_date',)):
    subtotal = defaultdict(dict)
    all_keys = set(list(team_data1.keys()))
    [all_keys.add(key) for key in team_data2.keys() if key]
    for k in all_keys:
        v1 = team_data1[k]
        v2 = team_data2[k]
        for k2 in v1.keys() or v2.keys():
            v21 = v1.get(k2) or (0.0 if k2 not in columns_str else '0')
            v22 = v2.get(k2) or (0.0 if k2 not in columns_str else '0')
            if k2 in columns_average:
                subtotal[k][k2] = (v21 * v1.get('matches_count', 0) + v22 * v2.get('matches_count', 0)) / (
                    v1.get('matches_count', 0) + v2.get('matches_count', 0))
            elif k2 in columns_max:
                subtotal[k][k2] = max(v21, v22)
            else:
                try:
                    sum = v21 if v21 and (isinstance(v21, float) and not math.isnan(v21)) else 0
                    sum += v22 if v22 and (isinstance(v21, float) and not math.isnan(v22)) else 0
                except Exception as e:
                    print(e)
                subtotal[k][k2] = sum
    return subtotal


if __name__ == '__main__':
    teams = {
        'home': defaultdict(dict),
        'away': defaultdict(dict),
        'subtotal': defaultdict(dict),
        'matches': defaultdict(dict),
    }
    # _test(teams)
    for league in LEAGUE_MAP:
        if not league or league != 'germany':
            continue
        _process_team_data(teams, league)
