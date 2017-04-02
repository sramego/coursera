x <- read.csv(file="seaflow_21min.csv",header=T,sep=",")
print(summary(x))
#    file_id           time          cell_id            d1       
# Min.   :203.0   Min.   : 12.0   Min.   :    0   Min.   : 1328  
# 1st Qu.:204.0   1st Qu.:174.0   1st Qu.: 7486   1st Qu.: 7296  
# Median :206.0   Median :362.0   Median :14995   Median :17728  
# Mean   :206.2   Mean   :341.5   Mean   :15008   Mean   :17039  
# 3rd Qu.:208.0   3rd Qu.:503.0   3rd Qu.:22401   3rd Qu.:24512  
# Max.   :209.0   Max.   :643.0   Max.   :32081   Max.   :54048  
#       d2          fsc_small        fsc_perp        fsc_big     
# Min.   :   32   Min.   :10005   Min.   :    0   Min.   :32384  
# 1st Qu.: 9584   1st Qu.:31341   1st Qu.:13496   1st Qu.:32400  
# Median :18512   Median :35483   Median :18069   Median :32400  
# Mean   :17437   Mean   :34919   Mean   :17646   Mean   :32405  
# 3rd Qu.:24656   3rd Qu.:39184   3rd Qu.:22243   3rd Qu.:32416  
# Max.   :54688   Max.   :65424   Max.   :63456   Max.   :32464  
#       pe          chl_small        chl_big           pop       
# Min.   :    0   Min.   : 3485   Min.   :    0   crypto :  102  
# 1st Qu.: 1635   1st Qu.:22525   1st Qu.: 2800   nano   :12698  
# Median : 2421   Median :30512   Median : 7744   pico   :20860  
# Mean   : 5325   Mean   :30164   Mean   : 8328   synecho:18146  
# 3rd Qu.: 5854   3rd Qu.:38299   3rd Qu.:12880   ultra  :20537  
# Max.   :58675   Max.   :64832   Max.   :57184                  

# Sample randomly 50% test and 50% training set
index <- sample(1:nrow(x), round(0.5*nrow(x)))
print(nrow(x[index, ]))
training <- x[index, ]
test <- x[-index, ]

# Plot the data
plot(x$pe, x$chl_small, col=x$pop)
legend("topleft", legend=levels(factor(x$pop)), text.col=seq_along(levels(factor(x$pop))))

# Train decision tree
library('rpart')
fol <- formula(pop ~ fsc_small + fsc_perp + fsc_big + pe + chl_big + chl_small)
model <- rpart(fol, method="class", data=training)
print(model)
#n= 36172 
#
#node), split, n, loss, yval, (yprob)
#      * denotes terminal node
#
# 1) root 36172 25702 pico (0.0015 0.18 0.29 0.25 0.28)  
#   2) pe< 5004 26301 15870 pico (0 0.22 0.4 3.8e-05 0.38)  
#     4) chl_small< 32548 11884  2242 pico (0 0.00017 0.81 8.4e-05 0.19) *
#     5) chl_small>=32548 14417  6618 ultra (0 0.4 0.055 0 0.54)  
#      10) chl_small>=41286.5 5185   665 nano (0 0.87 0 0 0.13) *
#      11) chl_small< 41286.5 9232  2098 ultra (0 0.14 0.085 0 0.77) *
#   3) pe>=5004 9871   749 synecho (0.0057 0.051 0.004 0.92 0.015)  
#     6) chl_small>=38881.5 619   125 nano (0.09 0.8 0 0.047 0.065) *
#     7) chl_small< 38881.5 9252   159 synecho (0 0.0015 0.0042 0.98 0.011) *

# Evaluate the accuracy
prediction <- predict(model,test,type='class')
accuracy <- sum(prediction == test$pop)/nrow(test)
print(accuracy)
# Good tutorial -> http://nthturn.com/2015/02/22/prediction-using-random-forests-in-r-an-example/
# 0.8568743

#Random Forest
library('randomForest')
model <- randomForest(fol, data=training)
prediction <- predict(model,test,type='class')
accuracy <- sum(prediction == test$pop)/nrow(test)
print(accuracy)
#0.9209588
# Importance gini values
importance(model)
#
#          MeanDecreaseGini
#fsc_small         2678.632
#fsc_perp          2003.052
#fsc_big            199.234
#pe                8932.779
#chl_big           4871.170
#chl_small         8172.300
#

# Support Vecotr Machine
install.packages("e1071")
library("e1071")
model <- svm(fol, data=training)
prediction <- predict(model,test,type='class')
accuracy <- sum(prediction == test$pop)/nrow(test)
print(accuracy)
# 0.9200741

# Confusion matrix
#rpart
> table(pred = prediction, true = test$pop)
#         true
#pred      crypto nano pico synecho ultra
#  crypto       0    0    0       0     0
#  nano        46 5047    1      31   697
#  pico         0    5 9593       1  2177
#  synecho      0   25   53    8991   116
#  ultra        0 1282  743       0  7363

# Random Forest
> table(pred = prediction, true = test$pop)
#         true
#pred      crypto  nano  pico synecho ultra
#  crypto      44     0     0       1     0
#  nano         2  5592     0       3   358
#  pico         0     0 10052       0  1373
#  synecho      0     2    14    9017     7
#  ultra        0   765   324       2  8615

# SVM
table(pred = prediction, true = test$pop)
#         true
#pred      crypto  nano  pico synecho ultra
#  crypto      43     0     0       2     0
#  nano         3  5633     0       2   403
#  pico         0     0 10008      17  1351
#  synecho      0     3    66    9001     4
#  ultra        0   723   316       1  8595

# Remove file_id:
x <- x[ ! x$file_id %in% c(208), ]
index <- sample(1:nrow(x), round(0.5*nrow(x)))
training <- x[index, ]
test <- x[-index, ]
fol <- formula(pop ~ fsc_small + fsc_perp + fsc_big + pe + chl_big + chl_small)
model <- svm(fol, data=training)
prediction <- predict(model,test,type='class')
accuracy <- sum(prediction == test$pop)/nrow(test)
# 0.973454 (0.0533799)


