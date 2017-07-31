# Author:   William Karasz
# Date:     7/30/2017
# Purpose:  Coursera Course 3 of Data Science Track, Week 4, Project

## Merge training and test set of data

# Set the working directory
setwd("c:/users/administrator/documents/coursera/course3")

# Download and extract the contents of the zip file
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "project_dataset.zip", method="libcurl", mode="wb")
unzip("project_dataset.zip", exdir="project_dataset")

## Merge the training and test data together (note: it was checked beforehand that the data sets are congruent with eachother)
if (!dir.exists("project_dataset/UCI HAR Dataset/combined")) {
  dir.create("project_dataset/UCI HAR Dataset/combined")
}
# Merge X data
file.copy("project_dataset/UCI HAR Dataset/train/X_train.txt", "project_dataset/UCI HAR Dataset/combined/X_combined.txt")
file.append("project_dataset/UCI HAR Dataset/combined/X_combined.txt", "project_dataset/UCI HAR Dataset/test/X_test.txt")
# Merge Y data
file.copy("project_dataset/UCI HAR Dataset/train/y_train.txt", "project_dataset/UCI HAR Dataset/combined/y_combined.txt")
file.append("project_dataset/UCI HAR Dataset/combined/y_combined.txt", "project_dataset/UCI HAR Dataset/test/y_test.txt")
# Merge subject data
file.copy("project_dataset/UCI HAR Dataset/train/subject_train.txt", "project_dataset/UCI HAR Dataset/combined/subject_combined.txt")
file.append("project_dataset/UCI HAR Dataset/combined/subject_combined.txt", "project_dataset/UCI HAR Dataset/test/subject_test.txt")


## Load only the measurments associated with mean and std for each measurement
# Read the column names
columnLabels <- read.csv("project_dataset/UCI HAR Dataset/features.txt", sep=" ", header=F)
use <- grepl("(mean\\(\\)|std\\(\\))..$",columnLabels$V2)
columnLabels[use,]

# Tag TRUE with numeric and FALSE with NULL
df <- data.frame(columnLabels,use)
dataColClasses <- with(df,ifelse(use,"numeric","NULL"))

# Read in the data (this step can take several minutes)
data <- read.fwf("project_dataset/UCI HAR Dataset/combined/X_combined.txt", 
                 widths=rep.int(16,561), col.names = columnLabels$V2, header = F,
                 buffersize = 100, colClasses=dataColClasses)

# Provide the descriptive names to the activities, and append to the data data frame
activity_labels <- read.csv("project_dataset/UCI HAR Dataset/activity_labels.txt", sep=" ", header=F)
activity_number <- read.csv("project_dataset/UCI HAR Dataset/combined/y_combined.txt", header=F)
data$activity <- activity_labels$V2[activity_number$V1]

# Append the subject number to each data line
data$subject_number <- read.csv("project_dataset/UCI HAR Dataset/combined/subject_combined.txt", header=F, col.names=c("subject no."))

# Pivot the data, independent tidy data set with the average of each variable for each activity and each subject
# Subject Activity Variable Value
# 1       Walking  tBodyAcc .5
# 1       Sitting  tBodyAcc .5
library(reshape2)
colnames(data)[1:48] <- gsub("-|\\(|\\)|\\.","",columnLabels[use,]$V2)


for (i in 1:30) {
  subject_i <- data[data$subject_number == i,]
  MeltData <- melt(subject_i,id=c("subject_number","activity"),measure.vars=colnames(data)[1:48])
  temptable <- cbind(subject=rep.int(i,6), dcast(MeltData,activity ~ variable,mean))
  if (i == 1) {
    newtable <- temptable
  } else {
    newtable <- rbind(newtable,temptable)
  }
}
# Results in data that looks like this...
#
#> head(newtable)
#subject           activity tBodyAccmeanX tBodyAccmeanY tBodyAccmeanZ tBodyAccstdX
#1       1             LAYING     0.2215982  -0.040513953    -0.1132036  -0.92805647
#2       1            SITTING     0.2612376  -0.001308288    -0.1045442  -0.97722901
#3       1           STANDING     0.2789176  -0.016137590    -0.1106018  -0.99575990
#4       1            WALKING     0.2773308  -0.017383819    -0.1111481  -0.28374026
#5       1 WALKING_DOWNSTAIRS     0.2891883  -0.009918505    -0.1075662   0.03003534
#6       1   WALKING_UPSTAIRS     0.2554617  -0.023953149    -0.0973020  -0.35470803
write.table(newtable, file="newtable_project_part5.txt", row.names=F)
