


#==============================================================================
# RUN ANALYSIS
#==============================================================================



# WORKING DIRECTORY
getwd()
setwd("/Users/Jonathan/Documents/R/Coursera/GettingCleaningData/CourseProject/")
getwd()



# DOWNLOAD FILE
if(!file.exists("./data")){dir.create("./data")}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destpath <- "./data/Dataset.zip"
download.file(url=fileurl, destfile=destpath, method="curl")
unzip(zipfile="./data/Dataset.zip", exdir="./data")



# LOAD PACKAGES
library(dplyr)
library(data.table)
library(tidyr)



# READ FILES
# filespath
filespath <- "./data/UCI HAR Dataset"
# subject training
subjecttrain <- tbl_df(read.table(file.path(filespath, "train", "subject_train.txt")))
# subject testing
subjecttest  <- tbl_df(read.table(file.path(filespath, "test", "subject_test.txt")))
# activity training
activitytrain <- tbl_df(read.table(file.path(filespath, "train", "Y_train.txt")))
# activity testing
activitytest  <- tbl_df(read.table(file.path(filespath, "test", "Y_test.txt")))
# data training
datatrain <- tbl_df(read.table(file.path(filespath, "train", "X_train.txt")))
# data testing
datatest  <- tbl_df(read.table(file.path(filespath, "test", "X_test.txt")))



# MERGE TRAINING AND TEST SETS INTO ONE DATA SET
# subject
subjectall <- rbind(subjecttrain, subjecttest)
setnames(subjectall, "V1", "subject")
# activity
activityall <- rbind(activitytrain, activitytest)
setnames(activityall, "V1", "activitynumber")
# data
dataall <- rbind(datatrain, datatest)
# name variables by feature
datafeatures <- tbl_df(read.table(file.path(filesPath, "features.txt")))
setnames(datafeatures, names(datafeatures), c("featurenumber", "featurename"))
colnames(dataall) <- datafeatures$featurename
# column names by activity labels
activitylabels <- tbl_df(read.table(file.path(filesPath, "activity_labels.txt")))
setnames(activitylabels, names(activitylabels), c("activitynumber", "activityname"))
# merge columns
subjectactivityall<- cbind(subjectall, activityall)
dataall <- cbind(subjectactivityall, dataall)



# EXTRACT AND MEASURE ONLY MEAN AND STANDARD DEVIATION
# extract
datafeaturesmusigma <- grep("mean\\(\\)|std\\(\\)", datafeatures$featurename, value=TRUE)
# measure
datafeaturesmusigma <- union(c("subject","activitynumber"), datafeaturesmusigma)
dataall<- subset(dataall, select=datafeaturesmusigma) 



# NAME ACTIVITIES DESCRIPTIVELY
dataall <- merge(activitylabels, dataall , by="activitynumber", all.x=TRUE)
dataall$activityname <- as.character(dataall$activityname)
dataall$activityname <- as.character(dataall$activityname)
dataaggregate <- aggregate(. ~ subject - activityname, data=dataall, mean) 
dataall<- tbl_df(arrange(dataall, subject, activityname))



# LABEL DATA SET WITH DESCRIPTIVE VARIABLE NAMES
head(str(dataall), 2)
names(dataall) <- gsub("std()", "SD", names(dataall))
names(dataall) <- gsub("mean()", "MEAN", names(dataall))
names(dataall) <- gsub("^t", "time", names(dataall))
names(dataall) <- gsub("^f", "frequency", names(dataall))
names(dataall) <- gsub("Acc", "Accelerometer", names(dataall))
names(dataall) <- gsub("Gyro", "Gyroscope", names(dataall))
names(dataall) <- gsub("Mag", "Magnitude", names(dataall))
names(dataall) <- gsub("BodyBody", "Body", names(dataall))
head(str(dataall), 6)



# CREATE TIDY DATA SET WITH AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND SUBJECT
write.table(dataall, "TidyData.txt", row.name=FALSE)


