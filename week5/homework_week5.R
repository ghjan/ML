# 书面作业
# 设计一指导足球博彩的分类器，以某足球队过往的比赛情况作为学习数据，预测在将要发生的赛事里，它将会获胜或输掉比赛？
# 可以得到的属性，包括球员身价，受伤，红黄牌，比赛中的射门，犯规，控球时间，角球，罚球等战术数据（大家可以自行想象）
# 描述你的思路，采用的算法，属性选取，模型构建等（尽管不要求具体数据和构建代码，但如果有同学能这么做必定可以获得老师极大赞赏）

#https://g.hupu.com/soccer/data_10854899.html
#1.球员层面的数据
#已经有了红黄牌，射门，犯规
#再加上 进球，助攻，射正率，出场时间 被犯 越位 扑救
#还缺乏下面的数据项： 球员身价，受伤，罚球
#其中球员身价和受伤情况比较重要
# home <- players$table_home_players_stats
# 位置  球员名 出场  时间  进球  助攻  射门  射正  射正率 黄牌  红牌  犯规  被犯  越位  扑救
#  门将 乌尔赖希  首发  90' 0 0 0 0 0%  0 0 0 0 0 3
#  后卫 胡梅尔斯  62' 换下  62' 0 0 1 1 100%  0 0 2 0 0 0
#  后卫 阿拉巴 首发  90' 0 0 0 0 0%  0 0 1 0 0 0
#  后卫 聚勒  首发  90' 1 0 1 1 100%  0 0 0 1 0 0
#  中场 里贝里 77' 换下  77' 0 0 0 0 0%  0 0 1 5 0 0
#  中场 比达尔 首发  90' 0 1 1 0 0%  1 0 2 0 0 0
#  中场 鲁迪  首发  90' 0 1 0 0 0%  0 0 0 0 0 0
#  中场 托利索 首发  90' 1 0 4 3 75% 0 0 2 4 0 0
#  中场 基米希 首发  90' 0 0 0 0 0%  0 0 0 2 0 0
#  前锋 穆勒  61' 换下  61' 0 0 1 1 100%  0 0 1 0 0 0
#  前锋 莱万多夫斯基  首发  90' 1 0 3 1 33% 0 0 1 2 3 0
#  后卫 拉菲尼亚  62' 出场  28' 0 0 0 0 0%  0 0 2 1 0 0
#  中场 罗本  61' 出场  29' 0 0 1 1 100%  0 0 0 1 1 0
#  门将 弗吕希特尔 替补  0'  0 0 0 0 0%  0 0 0 0 0 0
#  前锋 科曼  77' 出场  13' 0 0 1 0 0%  0 0 1 0 1 0
#  后卫 弗里德尔  替补  0'  0 0 0 0 0%  0 0 0 0 0 0
#  中场 桑谢斯 替补  0'  0 0 0 0 0%  0 0 0 0 0 0
#  前锋 潘托维奇  替补  0'  0 0 0 0 0%  0 0 0 0 0 0
# 总计        3 2 13  8 62% 1 0 13  16  5 3

# away <- players$table_away_players_stats
# 位置  球员名 出场  时间  进球  助攻  射门  射正  射正率 黄牌  红牌  犯规  被犯  越位  扑救
#  门将 莱诺  首发  90' 0 0 0 0 0%  0 0 0 0 0 5
#  后卫 斯文-本德 45' 换下  45' 0 0 0 0 0%  0 0 0 1 0 0
#  后卫 若纳唐-塔 首发  90' 0 0 0 0 0%  0 0 2 1 0 0
#  后卫 文德尔 首发  90' 0 0 2 0 0%  0 0 1 1 0 0
#  后卫 亨里希斯  首发  90' 0 0 0 0 0%  0 0 0 0 0 0
#  中场 贝拉拉比  首发  90' 0 0 6 0 0%  0 0 1 1 1 0
#  中场 多米尼克-科尔 首发  90' 0 0 3 0 0%  1 0 3 1 0 0
#  中场 阿朗吉斯  61' 换下  61' 0 0 0 0 0%  1 0 2 2 0 0
#  前锋 穆罕默迪  46' 换下  46' 1 0 2 2 100%  0 0 2 2 0 0
#  前锋 福兰德 首发  90' 0 0 1 1 100%  0 0 2 0 0 0
#  前锋 利昂-贝利 45' 换下  45' 0 0 1 0 0%  0 0 2 0 0 0
#  后卫 德拉戈维奇 45' 出场  45' 0 0 0 0 0%  0 0 1 1 0 0
#  中场 布兰特 46' 出场  44' 0 1 3 1 33% 0 0 1 1 0 0
#  中场 坎普尔 61' 出场  29' 0 0 1 0 0%  0 0 0 0 0 0
#  门将 厄兹詹 替补  0'  0 0 0 0 0%  0 0 0 0 0 0
#  中场 鲍姆加特林格  替补  0'  0 0 0 0 0%  0 0 0 0 0 0
#  中场 尤尔琴科  替补  0'  0 0 0 0 0%  0 0 0 0 0 0
#  前锋 波赫扬帕洛 替补  0'  0 0 0 0 0%  0 0 0 0 0 0
# 总计        1 1 19  4 21% 2 0 17  11  1 5
# 球队 相应列的数据在总计这一行
#没有控球率和角球数据

#2.球队某场比赛层面的数据
# players[3]$`NULL`
#     V1       V2       V3
# 1 拜仁 数据对比 勒沃库森
# players[5]$`NULL`  'data.frame'  必须把数据分割 而且我们已经有了部分数据，这里我们只需要控球率和角球数据
# 控球率 51%49%
# 射门  1319
# 射正  84
# 越位  51
# 角球  45
# 犯规  1317
# 黄牌  12
# 红牌  00
# 扑救  35

# players[6]$`NULL`
#    本场进球：3 赛季平均进球：2.32
# 1  本场失球：1 赛季平均失球：0.74
# 2 本场射门：13 赛季平均射门：9.76

# players[7]$`NULL`
#    本场进球：1 赛季平均进球：2.05
# 1  本场失球：3 赛季平均失球：1.42
# 2 本场射门：19 赛季平均射门：8.24

#3.球队赛季所有比赛的数据汇总
#赛季平均进球 赛季平均失球 赛季平均射门 

install.packages('RCurl')
install.packages('bitops')
install.packages("XML")
library(XML)
library(bitops)
library(RCurl)

setwd('R:/dataguru/ML/week5')
table_game <- read.csv('match.csv')
names(table_game) = 'match_number'

for i in table_game$match_number
  ##网站比赛编号，作为循环因子即可
  url <- sprintf('https://g.hupu.com/soccer/data_%d.html',i)
  temp <- getURL(url,encoding='utf-8')
  doc <-htmlParse(temp)
  players <- readHTMLTable(doc)
  home <- players$table_home_players_stats
  away <- players$table_away_players_stats
  ## 判断数据是否爬取，home_row,away_row均大于1说明数据成功爬取
  home_row <- nrow(home)
  away_row <- nrow(away)

## 球队平均每场犯规数绘制，其他图同理
library(ggplot2) 
p1 <- ggplot(league_stat,aes(x=联赛,y=平均每队犯规,fill=联赛))+
    geom_boxplot()+
    scale_color_few()+theme_economist()+ggtitle('球队平均每场犯规数')+
    theme(axis.title = element_blank(),
          plot.title = element_text(hjust=0.5,size=17),
          axis.text.x = element_text(size = 15),
          legend.position = 'NONE'
  )
## 设置subplot的行、列数
grid.newpage()
pushViewport(viewport(layout=grid.layout(2,2)))
vplayout<-function(x,y){viewport(layout.pos.row =x,layout.pos.col=y)}
## 将ggplot放置在subplot中
print(p1,vp=vplayout(1,1))
print(p2,vp=vplayout(1,2))
print(p3,vp=vplayout(2,1))

print(p4,vp=vplayout(2,2))