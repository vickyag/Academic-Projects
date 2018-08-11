library(stats)
library(boot)
################################ Q1 ####################################
data_points = readRDS("D:/MTech/Statistical Learning/Q1_data_02.Rda")
# 1.1
correlation = cor(data_points)
# 1.2
pairs(data_points, main = "Scatter-Plot Matrix")
# 1.4
linear_reg_model = lm(y~x1+x2+x3, data = data_points)

################################ Q2 ####################################

Q2_fun_01 = function(x)
{
  exp(-5*(x-0.3)^2)+0.5*exp(-100*(x-0.5)^2)+0.5*exp(-100*(x-0.75)^2)
}

Q2_fun_02 = function(x)
{
  2-3*x+10*x^4-5*x^9+6*x^14
}
# 2.1
curve(Q2_fun_01(x),-1,1)
curve(Q2_fun_02(x),-1,1)

# 2.2-2.3
set.seed(1343)
x1_points = sort(runif(100, min=-2, max=2))
y1_points = Q2_fun_01(x1_points)
y1_noisy = y1_points + rnorm(100)
degree8_model1 = lm(y1_noisy ~ poly(x1_points,8))
degree16_model1 = lm(y1_noisy ~ poly(x1_points,16))
degree28_model1 = lm(y1_noisy ~ poly(x1_points,28,raw=TRUE))
#print(degree28_model1)
plot(x1_points,y1_noisy,pch = 16,col = "blue",main = "'x' vs 'y_noise' Regression",xlab = "x",ylab = "y_noise")
predicted.intervals <- predict(degree8_model1,data.frame(x=x1_points),interval='confidence',level=0.99)
lines(x1_points,predicted.intervals[,1],col='red',lwd=2)
predicted.intervals <- predict(degree16_model1,data.frame(x=x1_points),interval='confidence',level=0.99)
lines(x1_points,predicted.intervals[,1],col='blue',lwd=2)
predicted.intervals <- predict(degree28_model1,data.frame(x=x1_points),interval='confidence',level=0.99)
lines(x1_points,predicted.intervals[,1],col='black',lwd=2)
legend("topright",legend=c("degree 8 fit", "degree 16 fit", "degree 28 fit"),col=c("red", "blue", "black"),lwd = 2)

# 2.2-2.3
x2_points = sort(runif(100, min=-2, max=2))
y2_points = Q2_fun_02(x1_points)
y2_noisy = y2_points + rnorm(100)
degree8_model2 = lm(y2_noisy ~ poly(x2_points,8))
degree16_model2 = lm(y2_noisy ~ poly(x2_points,16))
degree28_model2 = lm(y2_noisy ~ poly(x2_points,28,raw=TRUE))
#print(degree28_model1)
plot(x2_points,y2_noisy,pch = 16,col = "blue",main = "'x' vs 'y_noise' Regression",xlab = "x",ylab = "y_noise")
predicted.intervals <- predict(degree8_model2,data.frame(x=x1_points),interval='confidence',level=0.99)
lines(x2_points,predicted.intervals[,1],col='red',lwd=2)
predicted.intervals <- predict(degree16_model2,data.frame(x=x1_points),interval='confidence',level=0.99)
lines(x2_points,predicted.intervals[,1],col='blue',lwd=2)
predicted.intervals <- predict(degree28_model2,data.frame(x=x1_points),interval='confidence',level=0.99)
lines(x2_points,predicted.intervals[,1],col='black',lwd=2)
legend("topright",legend=c("degree 8 fit", "degree 16 fit", "degree 28 fit"),col=c("red", "blue", "black"),lwd = 2)

# 2.4-2.5
#for function 1
trainingset = data.frame(x1_points,y1_noisy)
crossvalidset = data.frame(x1_points,y1_noisy)
cv.err <- c()
for(i in 1:30)
{
  fit <- glm(y1_noisy ~ poly(x1_points, i,raw = TRUE), data=trainingset)
  fit
  cv.err[i] <- cv.glm(crossvalidset, fit, K=5)$delta[1]
}
plot(x = 1:30, y = cv.err, type='b',xlab = "Polynomial Degree", ylab = "Cross Validation Error", main = "Bias / Variance Tradeoff")

#for function 2
trainingset = data.frame(x2_points,y2_noisy)
crossvalidset = data.frame(x2_points,y2_noisy)
cv.err <- c()
for(i in 1:30)
{
  fit <- glm(y1_noisy ~ poly(x1_points, i,raw = TRUE), data=trainingset)
  fit
  cv.err[i] <- cv.glm(crossvalidset, fit, K=5)$delta[1]
}
plot(x = 1:30, y = cv.err, type='b',xlab = "Polynomial Degree", ylab = "Cross Validation Error", main = "Bias / Variance Tradeoff")