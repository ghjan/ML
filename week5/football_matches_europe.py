# -*- coding: utf-8 -*-
import datetime
import re

import requests

from week5.consts import HEADERS_GET, HEADERS_FORM
from week5.consts import LEAGUE_MAP
from week5.consts import PATTERN_HUPU_SOCCER_REPORT
from week5.consts import url_base, url
from week5.util import write_csv


def get_match_data(url_base, url, league_id):
    s = requests.Session()  # 自动处理cookie
    # 设置请求的headers，如果没有，服务器可能会没有响应
    headers = HEADERS_GET
    s.get(url_base, headers=headers)
    today = datetime.date.today()
    parameters = {
        'd': str(today).replace('-', ''),
        'type': 's',
        'league_id': league_id
    }
    # 设置请求的headers，如果没有，服务器可能会没有响应
    headers = HEADERS_FORM
    rsp = s.post(url, data=parameters, headers=headers)
    pattern = PATTERN_HUPU_SOCCER_REPORT
    all_match = re.findall(pattern, rsp.content.decode(encoding='utf-8'))
    match_set = set(all_match)
    return match_set


for k, v in LEAGUE_MAP.items():
    match_set = get_match_data(url_base.format(k), url, v)
    # 数据写入csv文件
    write_csv('match_{}.csv'.format(k), match_set)
