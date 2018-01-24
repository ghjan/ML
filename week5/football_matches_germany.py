import requests
import datetime
import re
from collections import Iterable
import csv

url_base = "https://soccer.hupu.com/germany/"
url = "https://soccer.hupu.com/schedule/schedule.server.php"

# 设置请求的headers，如果没有，服务器可能会没有响应
s = requests.Session()  # 自动处理cookie
user_agent = "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.81 Safari/537.36"
# 在headers中设置agent
headers = {"accept": 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
           "accept-encoding": "gzip, deflate, sdch, br",
           "accept-language": 'zh-CN,zh;q=0.8,en;q=0.6,zh-TW;q=0.4',
           "User-Agent": user_agent,
           }
s.get(url_base, headers=headers)

today = datetime.date.today()
parameters = {
    'd': str(today).replace('-', ''),
    'type': 's',
    'league_id': 5
}
content_type = "application/x-www-form-urlencoded"
# 设置请求的headers，如果没有，服务器可能会没有响应
headers = {"accept": '*/*', "accept-encoding": "gzip, deflate, br",
           "accept-language": 'zh-CN,zh;q=0.8,en;q=0.6,zh-TW;q=0.4',
           "User-Agent": user_agent,
           "content-type": content_type}
rsp = s.post(url, data=parameters, headers=headers)

pattern = "g\.hupu\.com\/soccer\/report\_(\d+)\.html"
all_match = re.findall(pattern, rsp.content.decode(encoding='utf-8'))
match_set = set(all_match)


def write_csv(filename, content, header=None):
    file = open(filename, "w")
    csvwriter = csv.writer(file, dialect=("excel"))
    if header:
        csvwriter.csvwriterow(header)
    for row in content:
        encoderow = list(row) if isinstance(row, Iterable) and type(
            row) != str else [row, ]
        csvwriter.writerow(encoderow)


# 数据写入csv文件
write_csv('match.csv', match_set)
