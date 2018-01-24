# 书面作业
# 设计一指导足球博彩的分类器，以某足球队过往的比赛情况作为学习数据，预测在将要发生的赛事里，它将会获胜或输掉比赛？
# 可以得到的属性，包括球员身价，受伤，红黄牌，比赛中的射门，犯规，控球时间，角球，罚球等战术数据（大家可以自行想象）
# 描述你的思路，采用的算法，属性选取，模型构建等（尽管不要求具体数据和构建代码，但如果有同学能这么做必定可以获得老师极大赞赏）

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