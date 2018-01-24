library(MASS)
##longley数据集，以多重共线性强而著称
longley

summary(fm1<-lm(Employed~., data=longley))
##相关系数t检验不理想
## R平方比较好

names(longley)[1] <- "y"
lm.ridge(y~., longley)
plot(lm.ridge(y~., longley,lambda=seq(0,0.1,0.001)))

select(lm.ridge(y~., longley, lambda=seq(0,0.1,0.001)))
## 三种不同的估计方法得到的lambda不一样
## 通常使用GCV估计，或者投票法 得到0.006

# install.packages('ridge')
## 如果发现ridge无法安装，试试用H2O包
##做岭回归吗？  用R建立岭回归和lasso回归。使用MASS包，里面有lm.ridge 函数。
## 用 glmnet 也可以做！呵呵，咱也是使用glmnet，那个caret也行哦！测试模式的程序包～
#install.packages("ridge", repos='http://cran.us.r-project.org')
#install.packages("ridge", repos='https://mirrors.ustc.edu.cn/CRAN/')
#install.packages("ridge", repos='http://mirrors.ustc.edu.cn/CRAN/')
# conda config --add channels r
# conda install ridge
library(ridge)
a = linearRidge(GNP.deflator~., data=longley)
summary(a)
