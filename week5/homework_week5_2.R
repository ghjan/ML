
library(XML)
library(bitops)
library(RCurl)

setwd('R:/dataguru/ML/week5')
table_game <- read.csv('match.csv')
names(table_game) = 'match_number'

percent_to_numeric <- function(x) {if(grepl("[0-9]+%",x))as.numeric(sub("%", "", x))/100 else x}

parse_team_data <-  function(data_season, march_index)
{
    # i=10854899
     
    ##网站比赛编号，作为循环因子即可
    url <- sprintf('https://g.hupu.com/soccer/data_%d.html',march_index)
    temp <- getURL(url,.encoding='utf-8')
    doc <-htmlParse(temp)
    players <- readHTMLTable(doc)
    home <- players$table_home_players_stats
    away <- players$table_away_players_stats

    home <- as.data.frame(lapply(home, percent_to_numeric))
    away <- as.data.frame(lapply(away, percent_to_numeric))
    ## 判断数据是否爬取，home_row,away_row均大于1说明数据成功爬取
    home_row <- nrow(home)
    away_row <- nrow(away)
    team_name_home <- as.character(players[3]$`NULL`[1,1])
    team_name_away <- as.character(players[3]$`NULL`[1,3])
    if(is.null(data_season$teams)){
        data_season$teams <-list()
    }

    if(team_name_home %in% names(data_season$teams)){
        data_team_saved_home = data_season$teams[[team_name_home]]
    }else{
        data_team_saved_home <-list()
    }
    if(team_name_away %in% names(data_season$teams)){
        data_team_saved_away = data_season$teams[[team_name_away]]
    }else{
        data_team_saved_away <-list()
    }
    for (j in seq(5,ncol(home))){
        colname <- colnames(home)[j]
        if (colname %in% names(data_team_saved_home)) {
          data_team_saved_home[[colname]] = as.numeric(data_team_saved_home[[colname]]) + as.numeric(as.character(home[home_row,j]))
        }else{
          data_team_saved_home[[colname]] = as.numeric(as.character(home[home_row,j]))
        }    
    }
    data_season$teams[[team_name_home]] = data_team_saved_home

    for (j in seq(5,ncol(away))){
      colname <- colnames(away)[j]
      if (colname %in% names(data_team_saved_away)) {
        data_team_saved_away[[colname]] = as.numeric(data_team_saved_away[[colname]]) + as.numeric(as.character(away[away_row,j]))
      }else{
        data_team_saved_away[[colname]] = as.numeric(as.character(away[away_row,j]))
      }    
    }
    data_season$teams[[team_name_away]] = data_team_saved_away
    return(data_season)
}
team_name_home
names(data_season$teams)
team_name_home %in% names(data_season$teams)

data_season <- list()
for( i in table_game$match_number){
  data_season <- parse_team_data(data_season, i)
}
