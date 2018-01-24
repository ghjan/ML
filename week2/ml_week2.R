快班机器学习第2课-线性回归与Logistic


线性回归、logistic回归
--------------------------
一元线性回归模型
体重～身高

薛毅 统计建模与R软件
exam0605.R  # 100*log(气压) ～沸点

多元线性回归模型

swiss数据集
Fertility~
R数据分析10里面也讲过这个例子
data(swiss)
fit2<-lm(Fertility~., data = swiss)
plot(fit2) 
summary(fit2)
    Coefficients:
                     Estimate Std. Error t value Pr(>|t|)    
    (Intercept)      66.91518   10.70604   6.250 1.91e-07 ***
    Agriculture      -0.17211    0.07030  -2.448  0.01873 *  
    Examination      -0.25801    0.25388  -1.016  0.31546    
    Education        -0.87094    0.18303  -4.758 2.43e-05 ***
    Catholic          0.10412    0.03526   2.953  0.00519 **
    Infant.Mortality  1.07705    0.38172   2.822  0.00734 **
    ---
    Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

    Residual standard error: 7.165 on 41 degrees of freedom
    Multiple R-squared:  0.7067,    Adjusted R-squared:  0.671
    F-statistic: 19.76 on 5 and 41 DF,  p-value: 5.594e-10

线性回归week3

exam0606.R

---------------------------------
虚拟变量-哑变量
离散的变量 因子的变量 

w h sex color

男女关于身高体重的关系不一样，所以引入sex是合理的
但是sex不是连续的。
同样的，不同肤色的人种也有不同的身高体重关系。
关于sex分拆为两个哑变量 isman iswoman
关于color分拆为三个哑变量 isy isw isb

第一种加法模型
w = a + bh+c isman +d *isy + e*isw + f

哑变量影响截距
第二种乘法模型
        先不考虑肤色
w = a + bh+c isman*h + d iswoman *h + e

        哑变量调整斜率
第三种 混合模型（加法模型+乘法模型）
w = a + bh+c1 isman + c isman*h + d1 iswoman+ d iswoman *h + e

---------------------------------
boston数据集 自学
R语言各个包里面的数据集
MASS
Boston
Housing Values in Suburbs of Boston
chas Charles River dummy variable (= 1 if tract bounds river; 0 otherwise).
lstat lower status of the population (percent).
medv median value of owner-occupied homes in \$1000s.

library(MASS)
data("Boston")
lm.fit = lm(medv~lstat+chas, data=Boston)
summary(lm.fit)

    Call:
    lm(formula = medv ~ lstat + chas, data = Boston)

    Residuals:
        Min      1Q  Median      3Q     Max
    -14.782  -3.798  -1.286   1.769  24.870

    Coefficients:
                Estimate Std. Error t value Pr(>|t|)    
    (Intercept) 34.09412    0.56067  60.809  < 2e-16 ***
    lstat       -0.94061    0.03804 -24.729  < 2e-16 ***
    chas         4.91998    1.06939   4.601 5.34e-06 ***
    ---
    Signif. codes:  
    0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

    Residual standard error: 6.095 on 503 degrees of freedom
    Multiple R-squared:  0.5626,    Adjusted R-squared:  0.5608
    F-statistic: 323.4 on 2 and 503 DF,  p-value: < 2.2e-16

plot(Boston$lstat, Boston$medv)
abline(lm.fit,col='red')

lm.fit = lm(medv~., data=Boston);
summary(lm.fit)

    Call:
    lm(formula = medv ~ ., data = Boston)

    Residuals:
        Min      1Q  Median      3Q     Max
    -15.595  -2.730  -0.518   1.777  26.199

    Coefficients:
                  Estimate Std. Error t value Pr(>|t|)    
    (Intercept)  3.646e+01  5.103e+00   7.144 3.28e-12 ***
    crim        -1.080e-01  3.286e-02  -3.287 0.001087 **
    zn           4.642e-02  1.373e-02   3.382 0.000778 ***
    indus        2.056e-02  6.150e-02   0.334 0.738288    
    chas         2.687e+00  8.616e-01   3.118 0.001925 **
    nox         -1.777e+01  3.820e+00  -4.651 4.25e-06 ***
    rm           3.810e+00  4.179e-01   9.116  < 2e-16 ***
    age          6.922e-04  1.321e-02   0.052 0.958229    
    dis         -1.476e+00  1.995e-01  -7.398 6.01e-13 ***
    rad          3.060e-01  6.635e-02   4.613 5.07e-06 ***
    tax         -1.233e-02  3.760e-03  -3.280 0.001112 **
    ptratio     -9.527e-01  1.308e-01  -7.283 1.31e-12 ***
    black        9.312e-03  2.686e-03   3.467 0.000573 ***
    lstat       -5.248e-01  5.072e-02 -10.347  < 2e-16 ***
    ---
    Signif. codes:  
    0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

    Residual standard error: 4.745 on 492 degrees of freedom
    Multiple R-squared:  0.7406,    Adjusted R-squared:  0.7338
    F-statistic: 108.1 on 13 and 492 DF,  p-value: < 2.2e-16


多元线性回归的核心问题-变量选择
逐步回归和step()

使用drop1作删除试探，使用add1函数作增加试探
--------------------视频ML02f
回归诊断
 可以参考R数据分析10
正态分布检验 我们后面将主要针对模型残差做正态分布检验
函数shapiro.test()
p>0.05,正态性分布

shapiro.test(x$政治X1)
        Shapiro-Wilk normality test

    data:  x$政治X1
    W = 0.88015, p-value = 0.08803

shapiro.test(x$物理X5)
        Shapiro-Wilk normality test

    data:  x$物理X5
    W = 0.75975, p-value = 0.003384

散点图目测检验
薛毅书例子 p336
例子 6.11 exam0611.R

自学这个例子
------------------
残差
    残差计算函数residuals()
    对残差作正态性检验
    残差图

------------------
残差做W正态性检验

例子6.12 

y.res<- residuals(lm.sol)
shapiro.test(y.res)
Shapiro-Wilk normality test

        Shapiro-Wilk normality test

    data:  y.res
    W = 0.54654, p-value = 3.302e-06

残差不满足正态性假设！怎么看这个数据？

> y12.res<-residuals(lm12) #去掉第12样本点（离群值）
> shapiro.test(y12.res)

        Shapiro-Wilk normality test

    data:  y12.res
    W = 0.92215, p-value = 0.1827

能够通过正态性检验，因此，去掉第12号样本点还是合理的。    
------------------
薛毅书p346例6.14
# 营销策略
# 销售情况
# 家庭人均购买量Y
# 家庭人均收入X

X<-scan()
 679  292 1012  493  582 1156  997 2189 1097 2078
1818 1700  747 2030 1643  414  354 1276  745  435
 540  874 1543 1029  710 1434  837 1748 1381 1428 
1255 1777  370 2316 1130  463  770  724  808  790
 783  406 1242  658 1746  468 1114  413 1787 3560
1495 2221 1526

Y<-scan()
0.79 0.44 0.56 0.79 2.70 3.64 4.73 9.50 5.34 6.85
5.84 5.21 3.25 4.43 3.16 0.50 0.17 1.88 0.77 1.39 
0.56 1.56 5.28 0.64 4.00 0.31 4.20 4.88 3.48 7.58 
2.63 4.99 0.59 8.19 4.79 0.51 1.74 4.10 3.94 0.96
3.29 0.44 3.24 2.14 5.71 0.64 1.90 0.51 8.33 14.94
5.11 3.85 3.93

lm.sol<-lm(Y~X); summary(lm.sol)
y.rst<-rstandard(lm.sol); y.fit<-predict(lm.sol)
plot(y.rst~y.fit)
abline(0.1,0.5);abline(-0.1,-0.5) 
##发现残差图和漏斗差不多

lm.new<-update(lm.sol, sqrt(.)~.); coef(lm.new)
yn.rst<-rstandard(lm.new); yn.fit<-predict(lm.new)
plot(yn.rst~yn.fit)
##看起来比刚才好一些了
------------
其实画残差图还有更加方便的方法
data(iris)
lm.iris <- lm(iris$Sepal.Length~iris$Sepal.Width) 
plot(lm.iris)
# 第一张图就是残差图 残差的正态分布性 比较随机均匀分布在x轴附近
# 第二张图是Normal Q-Q图 残差的正态分布性 也会显示高杠杆值 偏离值
# 第三张图是Scale-Location图 残差的同方差性 比较均匀的分布在水平线附近
# 第四张图是Residuals vs. leverage 看高杠杆值 Cook距离用来检测是否强影响点 

R数据分析10 
R语言实战读书笔记(八)回归
http://www.cnblogs.com/MarsMercury/p/5004942.html
Rvs.F还算比较随机均匀分布在x轴附近
S-L图也是比较均匀的分布在水平线附近
QQ图里面15仍然是一个高杠杆值
QQ图13这个点偏离比较大



残差的独立性
durbinWatsonTest(lm.fit)
大于0.05，无法拒绝零假设：相互独立
-------------------------
多重共线性

  什么是多重共线性
    线性相关
多重共线性对回归模型的影响
    非独立变量没有必要在回归模型存在，求解回归模型的时候，有个关键矩阵不可逆（行列式为0）
    就算不是绝对的零，还是可以求得逆矩阵，但是使得逆矩阵计算非常不稳定。求出来的误差就比较大。
利用计算特征根发现多重共线性
    从特征向量里面剔除特征值比较小的
    最大特征根和最小特征根相比较 这个比例就是kappa值
Kappa()函数

多重共线性
多元线性回归
非独立的自变量：有一些变量其实可以通过其他变量的组合产生
逐步 step()可以去掉这些非独立的自变量

利用计算特征根发现多重共线性
近似共线性

kappa()函数
计算矩阵的条件数
<100 共线性的程度很小
>1000 认为有比较严重的共线性


例6-18
##相关系数矩阵
XX<-cor(collinear[2:7])
kappa(XX,exact=TRUE)
    [1] 2195.908
    eigen(XX)
    > eigen(XX)
    eigen() decomposition
    $values
    [1] 2.428787365 1.546152096 0.922077664 0.793984690 0.307892134 0.001106051
    $vectors
               [,1]        [,2]        [,3]        [,4]       [,5]         [,6]
    [1,] -0.3907189  0.33968212  0.67980398 -0.07990398  0.2510370 -0.447679719
    [2,] -0.4556030  0.05392140 -0.70012501 -0.05768633  0.3444655 -0.421140280
    [3,]  0.4826405  0.45332584 -0.16077736 -0.19102517 -0.4536372 -0.541689124
    [4,]  0.1876590 -0.73546592  0.13587323  0.27645223 -0.0152087 -0.573371872
    [5,] -0.4977330  0.09713874 -0.03185053  0.56356440 -0.6512834 -0.006052127
    [6,]  0.3519499  0.35476494 -0.04864335  0.74817535  0.4337463 -0.002166594

我们就把最小的特征根对应的特征向量剔除

另外一种方法
vif(fit)
sqrt(vif(fit)) > 2 #>2说明有多重共线性
Population Illiteracy Income Frost 
FALSE FALSE FALSE FALSE
=====================
广义线性模型
    可以参考R数据分析9

看起来并不是一根直线
    a=c(0:5)
    b=c(0,0.129,0.3,0.671,0.857,0.9)
    plot(a,b)

    s型曲线
    用线性回归效果不好
    是不是能够用非线性回归呢？
    预定一个函数方程 多项式 正切函数 指数函数 对数函数 幂函数 
    在数学上面不大好解
    不能使用最小二乘法 只能用牛顿速降法 不方便

    广义线性回归是说有一些非线性回归可以转换为线性回归
--------------------
logistic回归模型
例子 6.19
Norell实验  牛对小电流的反应

norell<-data.frame(
   x=0:5, n=rep(70,6), success=c(0,9,21,47,60,63)
)
norell$Ymat<-cbind(norell$success, norell$n-norell$success)
#glm 就是广义线性模型
glm.sol<-glm(Ymat~x, 
    family=binomial,  #加了这个就是说在做logistic回归
    data=norell)
summary(glm.sol)

    Call:
    glm(formula = Ymat ~ x, family = binomial, data = norell)

    Deviance Residuals:
          1        2        3        4        5        6  
    -2.2507   0.3892  -0.1466   1.1080   0.3234  -1.6679  

    Coefficients:
                Estimate Std. Error z value Pr(>|z|)    
    (Intercept)  -3.3010     0.3238  -10.20   <2e-16 ***
    x             1.2459     0.1119   11.13   <2e-16 ***
    ---
    Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

    (Dispersion parameter for binomial family taken to be 1)

        Null deviance: 250.4866  on 5  degrees of freedom
    Residual deviance:   9.3526  on 4  degrees of freedom
    AIC: 34.093

    Number of Fisher Scoring iterations: 4
pre<-predict(glm.sol, data.frame(x=3.5))
p<-exp(pre)/(1+exp(pre));p

X<- - glm.sol$coefficients[1]/glm.sol$coefficients[2];X

d<-seq(0,5, len=100)
pre<-predict(glm.sol, data.frame(x=d))
p<-exp(pre)/(1+exp(pre))
norell$y<-norell$success/norell$n
plot(norell$x,norell$y)
lines(d,p)

富士康跳楼曲线据说也是logistic回归

logit函数
logit变换



----------------------

多元的情况
逐步回归 
step()函数

其他广义线性回归 大家可以自己看书

扩展 自学
R中还有不少扩展的Logistic回归和变种：

    * 稳健Logistic回归 robust 包中的 glmRob() 函数可用来拟合稳健的广义线性模型，包括稳健Logistic回归。
    * 多项分布回归 若响应变量包含两个以上的无序类别(比如,已婚/寡居/离婚)，便可使用 mlogit 包中的 mlogit() 函数拟合多项Logistic回归。
    * 序数Logistic回归 若响应变量是一组有序的类别(比如,信用风险为差/良/好)，便可使用 rms 包中的 lrm() 函数拟合序数Logistic回归。

泊松回归
    如果我们将兴趣从是否有婚外情转移到过去一年中婚外情的次数，便可以直接泊松回归对计数型数据进行分析。


==========================视频ML02g
非线性模型

例子：销售额x与流通费率y
    流通费率 流通环节的耗费  人力 广告 
x=c(1.5,2.8,4.5,7.5,10.5,13.5,15.1,16.5,19.5,22.5,24.5,26.5)
y=c(7.0,5.5,4.6,3.6,2.9,2.7,2.5,2.4,2.2,2.1,1.9,1.8)
plot(x,y)

lm.1=lm(y~x)
summary(lm.1)

    Call:
    lm(formula = y ~ x)

    Residuals:
        Min      1Q  Median      3Q     Max
    -0.9179 -0.5537 -0.1628  0.3953  1.6519

    Coefficients:
                Estimate Std. Error t value Pr(>|t|)    
    (Intercept)  5.60316    0.43474  12.889 1.49e-07 ***
    x           -0.17003    0.02719  -6.254 9.46e-05 ***
    ---
    Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

    Residual standard error: 0.7701 on 10 degrees of freedom
    Multiple R-squared:  0.7964,    Adjusted R-squared:  0.776
    F-statistic: 39.11 on 1 and 10 DF,  p-value: 9.456e-05

    R-squared不理想 数据不多的情况下面0.79比较糟糕
    线性模型失败
-------------------
x1=x
x2=x^2
lm.2=lm(y~x1+x2)
summary(lm.2)
    Coefficients:
                 Estimate Std. Error t value Pr(>|t|)    
    (Intercept)  6.914687   0.331987  20.828 6.35e-09 ***
    x1          -0.465631   0.056969  -8.173 1.86e-05 ***
    x2           0.010757   0.002009   5.353  0.00046 ***
    ---
    Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

    Residual standard error: 0.3969 on 9 degrees of freedom
    Multiple R-squared:  0.9513,    Adjusted R-squared:  0.9405 
    F-statistic: 87.97 on 2 and 9 DF,  p-value: 1.237e-06
plot(x,y)
lines(x,fitted(lm.2))

-------------------
对数法  y=a+b*logx
lm.log=lm(y~log(x))
summary(lm.log)
    Call:
    lm(formula = y ~ log(x))

    Residuals:
         Min       1Q   Median       3Q      Max
    -0.33291 -0.10133 -0.04693  0.16512  0.34844

    Coefficients:
                Estimate Std. Error t value Pr(>|t|)    
    (Intercept)   7.3639     0.1688   43.64 9.60e-13 ***
    log(x)       -1.7568     0.0677  -25.95 1.66e-10 ***
    ---
    Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

    Residual standard error: 0.2064 on 10 degrees of freedom
    Multiple R-squared:  0.9854,    Adjusted R-squared:  0.9839
    F-statistic: 673.5 on 1 and 10 DF,  p-value: 1.66e-10

plot(x,y)
# fitted() Extract Model Fitted Values
lines(x,fitted(lm.log))

-----------------------
指数法 y = a*exp(b*x)
两边取log
lm.exp=lm(log(y)~x)
summary(lm.exp)


    Call:
    lm(formula = log(y) ~ x)

    Residuals:
         Min       1Q   Median       3Q      Max
    -0.18246 -0.10664 -0.01670  0.08079  0.25946

    Coefficients:
                 Estimate Std. Error t value Pr(>|t|)    
    (Intercept)  1.759664   0.075101   23.43 4.54e-10 ***
    x           -0.048809   0.004697  -10.39 1.12e-06 ***
    ---
    Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

    Residual standard error: 0.133 on 10 degrees of freedom
    Multiple R-squared:  0.9153,    Adjusted R-squared:  0.9068
    F-statistic:   108 on 1 and 10 DF,  p-value: 1.116e-06
plot(x,y)
lines(x,exp(fitted(lm.exp)))

-------------------
幂函数法 y=a*power(x,b)
lm.pow=lm(log(y)~log(x))
summary(lm.pow)

    Call:
    lm(formula = log(y) ~ log(x))

    Residuals:
          Min        1Q    Median        3Q       Max
    -0.054727 -0.020805  0.004548  0.024617  0.045896

    Coefficients:
                Estimate Std. Error t value Pr(>|t|)    
    (Intercept)  2.19073    0.02951   74.23 4.81e-15 ***
    log(x)      -0.47243    0.01184  -39.90 2.34e-12 ***
    ---
    Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

    Residual standard error: 0.0361 on 10 degrees of freedom
    Multiple R-squared:  0.9938,    Adjusted R-squared:  0.9931
    F-statistic:  1592 on 1 and 10 DF,  p-value: 2.337e-12

plot(x,y)
lines(x,exp(fitted(lm.pow)))

在t检验和F检验都满足的情况下面，
幂函数模型的R平方是最接近1的
所以决定采用这个幂函数模型

--------------
多项式回归模型
    理论上可以拟合任意的散点
    次数足够高 一定可以拟合
    不过容易出现过度拟合的情况

内在非线性都用多项式回归模型来拟合
例子 P378

P381 例6.21
解释这一堆数是什么意思。
poly(alloy$x, degree = 2)
1 2
[1,] -4.447496e-01 0.49168917
[2,] -3.706247e-01 0.24584459
[3,] -2.964997e-01 0.04469902
[4,] -2.223748e-01 -0.11174754
[5,] -1.482499e-01 -0.22349508
[6,] -7.412493e-02 -0.29054360
[7,] -1.645904e-17 -0.31289311
[8,] 7.412493e-02 -0.29054360
[9,] 1.482499e-01 -0.22349508
[10,] 2.223748e-01 -0.11174754
[11,] 2.964997e-01 0.04469902
[12,] 3.706247e-01 0.24584459
[13,] 4.447496e-01 0.49168917

这是正交向量

-------------
非线性最小二乘问题 自学
nls()函数
用来做非线性回归模型的参数估计
例子薛毅书P384

======================视频ML02h
案例分析——预测网页流量
参考R数据分析8

来自于一本书《机器学习实用案例解析》

使用互联网排名前1000的网站的数据
Rank：排名
PageViews：网站访问量
UniqueVisitor：访问用户数目(cookies)
HasAdvertising：是否有广告
IsEnglish：主要使用的语言是否为英语

-----------------
哑变量 
   有些变量比较特殊
   如性别 黄种人 黑种人

R语言中生成虚拟变量/哑变量
----
多重共线性
    多重共线性（Multicollinearity）是指线性回归模型中的解释变量之间由于存在精确相关关系或高度相关关系而使模型估计失真或难以估计准确。
    一般来说，由于经济数据的限制使得模型设计不当，导致设计矩阵中解释变量间存在普遍的相关关系。
    完全共线性的情况并不多见，一般出现的是在一定程度上的共线性，即近似共线性。

降维分析
  主成分分析 因子分析（R数据分析14, ML4）
  多重共线性自动就去掉了

岭回归以及lasso回归  （ML3)
    step()只能得到次优解 有时候甚至是很荒谬的解
    比较巧妙的选择合适的变量，比较高深的技术，数据挖掘的味道出来了

------------
ggplot2 免费课程
