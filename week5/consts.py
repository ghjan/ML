LEAGUE_MAP = {
    'england': 2,
    'spain': 3,
    'italy': 4,
    'germany': 5,
    'france': 6,
}
url_base = "https://soccer.hupu.com/{}/"
url = "https://soccer.hupu.com/schedule/schedule.server.php"

USER_AGENT = "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.81 Safari/537.36"

HEADERS_GET = {"accept": 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
               "accept-encoding": "gzip, deflate, sdch, br",
               "accept-language": 'zh-CN,zh;q=0.8,en;q=0.6,zh-TW;q=0.4',
               "User-Agent": USER_AGENT,
               }

# 设置请求的headers，如果没有，服务器可能会没有响应
HEADERS_FORM = {"accept": '*/*', "accept-encoding": "gzip, deflate, br",
                "accept-language": 'zh-CN,zh;q=0.8,en;q=0.6,zh-TW;q=0.4',
                "User-Agent": USER_AGENT,
                "content-type": "application/x-www-form-urlencoded"}

PATTERN_HUPU_SOCCER_REPORT = "g\.hupu\.com\/soccer\/report\_(\d+)\.html"
