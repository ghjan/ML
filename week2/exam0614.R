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

lm.new<-update(lm.sol, sqrt(.)~.); coef(lm.new)
yn.rst<-rstandard(lm.new); yn.fit<-predict(lm.new)
plot(yn.rst~yn.fit)

##误差的独立性
library(car)
durbinWatsonTest(lm.sol)
durbinWatsonTest(lm.new)

##线性模型是否适合
###成分残差图(component plus residual)
crPlots(lm.sol, one.page=T, ask=F)
crPlots(lm.new, one.page=T, ask=F)

##等方差性
###记分检验 p>0.05 等方差性 否则就是异方差性
ncvTest(lm.sol)
ncvTest(lm.new)
###散点图
###car包spreadLevelPlot()函数创建一个添加了最佳拟合曲线的散点图，展示标准化残差绝对值与拟合值的关系。
### 同方差性的条件下，点应在线的周围水平随机分布。非水平的曲线暗示着异方差性。
### 看起来lm.new的散点更加均匀分布在红线上下
spreadLevelPlot(lm.sol)
spreadLevelPlot(lm.new)

##异常观察值
###离群点检测-outlierTest()
###根据带个最大残差值的离群点
###如果p值大于0.05 我们就认为没有显著的离群点
###如果小于0.05,存在显著的离群点；如果要看其他的离群点，可以先删除最大的离群点
outlierTest(lm.sol)
outlierTest(lm.new)
