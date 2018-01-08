# 100*log(气压) ～沸点
X<-matrix(c(
194.5, 20.79, 1.3179, 131.79,
194.3, 20.79, 1.3179, 131.79,
197.9, 22.40, 1.3502, 135.02,
198.4, 22.67, 1.3555, 135.55,
199.4, 23.15, 1.3646, 136.46,
199.9, 23.35, 1.3683, 136.83,
200.9, 23.89, 1.3782, 137.82,
201.1, 23.99, 1.3800, 138.00,
201.4, 24.02, 1.3806, 138.06,
201.3, 24.01, 1.3805, 138.05,
203.6, 25.14, 1.4004, 140.04,
204.6, 26.57, 1.4244, 142.44,
209.5, 28.49, 1.4547, 145.47,
208.6, 27.76, 1.4434, 144.34,
210.7, 29.04, 1.4630, 146.30,
211.9, 29.88, 1.4754, 147.54,
212.2, 30.06, 1.4780, 147.80),
ncol=4, byrow=T,
dimnames = list(1:17, c("F", "h", "log", "log100")))

forbes<-data.frame(X)
plot(forbes$F, forbes$log100)
lm.sol<-lm(log100~F, data=forbes)
summary(lm.sol)
abline(lm.sol)

y.res<-residuals(lm.sol);plot(y.res)
text(12,y.res[12], labels=12,adj=1.2)


i<-1:17; forbes12<-data.frame(X[i!=12, ])
lm12<-lm(log100~F, data=forbes12)
summary(lm12)

##误差的独立性
library(car)
durbinWatsonTest(lm.sol)
durbinWatsonTest(lm12)

##线性模型是否适合
##成分残差图(component plus residual)
crPlots(lm.sol, one.page=T, ask=F)
crPlots(lm12, one.page=T, ask=F)

##等方差性
###记分检验 p>0.05 等方差性 否则就是异方差性
ncv.test(lm.sol)
ncv.test(lm12)
###散点图
###car包spreadLevelPlot()函数创建一个添加了最佳拟合曲线的散点图，展示标准化残差绝对值与拟合值的关系。
### 同方差性的条件下，点应在线的周围水平随机分布。非水平的曲线暗示着异方差性。
###最理想的是红线比较水平的线 不会有倾斜 lm12比较好
spreadLevelPlot(lm.sol)
spreadLevelPlot(lm12)

##综合检验
library(gvlma)
gvmodel <- gvlma(lm.sol)
summary(gvmodel)
