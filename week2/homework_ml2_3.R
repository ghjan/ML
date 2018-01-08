#案例分析-预测网页流量
#
setwd('R:/dataguru/ML/week2')
library(ggplot2)
top.1000.sites <- read.csv('top_1000_sites.tsv', sep='/t', stringsAsFactors = F)
ggplot(data=top.1000.sites, mapping=aes(x=PageViews, y = UniqueVisitors)) + geom_point()
#数据很不均匀 几种在左下角
#数据间差异太大，可以考虑对数变换
ggplot(data=top.1000.sites, mapping=aes(x=log(PageViews), y =log(UniqueVisitors) )) + geom_point()
lm.fit <- lm(log(PageViews)~log(UniqueVisitors), data=top.1000.sites) 
summary(lm.fit)

    Call:
    lm(formula = log(PageViews) ~ log(UniqueVisitors), data = top.1000.sites)

    Residuals:
        Min      1Q  Median      3Q     Max 
    -2.1825 -0.7986 -0.0741  0.6467  5.1549 

    Coefficients:
                        Estimate Std. Error t value Pr(>|t|)    
    (Intercept)         -2.83441    0.75201  -3.769 0.000173 ***
    log(UniqueVisitors)  1.33628    0.04568  29.251  < 2e-16 ***
    ---
    Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

    Residual standard error: 1.084 on 998 degrees of freedom
    Multiple R-squared:  0.4616,    Adjusted R-squared:  0.4611 
    F-statistic: 855.6 on 1 and 998 DF,  p-value: < 2.2e-16

    看起来显著性还不错

#多元线性回归
lm.mfit <- lm(log(PageViews) ~ HasAdvertising+log(UniqueVisitors) + InEnglish, data=top.1000.sites)
summary(lm.mfit)

    Call:
    lm(formula = log(PageViews) ~ HasAdvertising + log(UniqueVisitors) + 
        InEnglish, data = top.1000.sites)

    Residuals:
        Min      1Q  Median      3Q     Max 
    -2.4283 -0.7685 -0.0632  0.6298  5.4133 

    Coefficients:
                        Estimate Std. Error t value Pr(>|t|)    
    (Intercept)         -1.94502    1.14777  -1.695  0.09046 .  
    HasAdvertisingYes    0.30595    0.09170   3.336  0.00088 ***
    log(UniqueVisitors)  1.26507    0.07053  17.936  < 2e-16 ***
    InEnglishNo          0.83468    0.20860   4.001 6.77e-05 ***
    InEnglishYes        -0.16913    0.20424  -0.828  0.40780    
    ---
    Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

    Residual standard error: 1.067 on 995 degrees of freedom
    Multiple R-squared:  0.4798,    Adjusted R-squared:  0.4777 
    F-statistic: 229.4 on 4 and 995 DF,  p-value: < 2.2e-16

R对InEnglish自动做了哑变量，NO表示哑变量
最好自己先做好哑变量，而不是等着R去做
模型不是很理想
截距只有.
可以去除一些变量
留着作业，试一试

lm.mfit2 = drop1(lm.mfit)
lm.mfit2
    Single term deletions

    Model:
    log(PageViews) ~ HasAdvertising + log(UniqueVisitors) + InEnglish
                        Df Sum of Sq    RSS    AIC
    <none>                           1132.4 134.32
    HasAdvertising       1     12.67 1145.0 143.45
    log(UniqueVisitors)  1    366.13 1498.5 412.47
    InEnglish            2     27.92 1160.3 154.68

去掉HasAdvertising，AIC增加最少，RSS的增加也是最少。
所以试一试去掉HasAdvertising

lm.mfit3 <- lm(log(PageViews) ~ log(UniqueVisitors) + InEnglish, data=top.1000.sites)
summary(lm.mfit3)

    Call:
    lm(formula = log(PageViews) ~ log(UniqueVisitors) + InEnglish, 
        data = top.1000.sites)

    Residuals:
        Min      1Q  Median      3Q     Max 
    -2.6824 -0.8015 -0.0636  0.6500  5.1590 

    Coefficients:
                        Estimate Std. Error t value Pr(>|t|)    
    (Intercept)         -1.77178    1.15241  -1.537    0.125    
    log(UniqueVisitors)  1.27010    0.07087  17.921  < 2e-16 ***
    InEnglishNo          0.82590    0.20965   3.940 8.73e-05 ***
    InEnglishYes        -0.15480    0.20523  -0.754    0.451    
    ---
    Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

    Residual standard error: 1.072 on 996 degrees of freedom
    Multiple R-squared:  0.474, Adjusted R-squared:  0.4724 
    F-statistic: 299.1 on 3 and 996 DF,  p-value: < 2.2e-16

效果不理想
于是尝试去掉InEnglish
lm.mfit4 <- lm(log(PageViews) ~HasAdvertising+ log(UniqueVisitors), data=top.1000.sites)
summary(lm.mfit4)

    Call:
    lm(formula = log(PageViews) ~ HasAdvertising + log(UniqueVisitors), 
        data = top.1000.sites)

    Residuals:
        Min      1Q  Median      3Q     Max 
    -2.1933 -0.7652 -0.0800  0.6392  5.3986 

    Coefficients:
                        Estimate Std. Error t value Pr(>|t|)    
    (Intercept)         -2.97383    0.74993  -3.965 7.85e-05 ***
    HasAdvertisingYes    0.29335    0.09268   3.165   0.0016 ** 
    log(UniqueVisitors)  1.32981    0.04552  29.211  < 2e-16 ***
    ---
    Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

    Residual standard error: 1.079 on 997 degrees of freedom
    Multiple R-squared:  0.467, Adjusted R-squared:  0.4659 
    F-statistic: 436.7 on 2 and 997 DF,  p-value: < 2.2e-16

这个比较理想一些，t检验和F检验都理想了，虽然R平方仍然没有什么改善。