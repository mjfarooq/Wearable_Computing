
rm(list=ls())
library(dplyr)
library(reshape2)
library("plyr")


activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")

X_train <- read.table("train\\X_train.txt")
y_train <- read.table("train\\y_train.txt")
subject_train <- read.table("train\\subject_train.txt")

X_test <- read.table("test\\X_test.txt")
y_test <- read.table("test\\y_test.txt")
subject_test <- read.table("test\\subject_test.txt")

X_test_train <- rbind(X_test, X_train)
y_test_train <- rbind(y_test, y_train)
subject_test_train <- rbind(subject_test,subject_train)



mean_cols_index <- grep("mean", features$V2)
std_cols_index <- grep("std", features$V2)
mean_col_names <- features$V2[as.numeric(mean_cols_index)]
std_col_names <- features$V2[as.numeric(std_cols_index)] 
mean_cols_test_train <- X_test_train[,mean_cols_index]
std_cols_test_train <- X_test_train[,std_cols_index]



Tidy_data <- cbind(subject_test_train,y_test_train,mean_cols_test_train,std_cols_test_train )



melted_data <- melt(Tidy_data , id.vars = c("Subject","Activity"))

casted_data <- dcast(melted_data, Subject + Activity ~ variable , fun.aggregate = mean)
c <- data.frame(V1 = casted_data$Activity)
b <- join(c,activity_labels)
casted_data$Activity <- b$V2

Final_tidy_data <- casted_data
colnames(Final_tidy_data) = c("Subject", "Activity", as.character(mean_col_names), as.character(std_col_names))

write.table(Final_tidy_data, file = "Tidy_data_set.txt", row.name = F, sep ="\t")