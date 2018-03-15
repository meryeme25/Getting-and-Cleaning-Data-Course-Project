
library(dplyr)


zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "dataset.zip"

if (!file.exists(zipFile)) {
  download.file(zipUrl, zipFile, mode = "wb")
}

dataPath <- "UCI HAR Dataset"
if (!file.exists(dataPath)) {
  unzip(zipFile)
}

# read training data from files 
trainingSubjects <- read.table(file.path(dataPath, "train", "subject_train.txt"))
trainingValues <- read.table(file.path(dataPath, "train", "X_train.txt"))
trainingActivity <- read.table(file.path(dataPath, "train", "y_train.txt"))

# read test data from files 
testSubjects <- read.table(file.path(dataPath, "test", "subject_test.txt"))
testValues <- read.table(file.path(dataPath, "test", "X_test.txt"))
testActivity <- read.table(file.path(dataPath, "test", "y_test.txt"))

# Loading the activity labels and features
features <- read.table(file.path(dataPath, "features.txt"), as.is = TRUE)
activities <- read.table(file.path(dataPath, "activity_labels.txt"))
colnames(activities) <- c("activityId", "activityLabel")


HActivity <- rbind(
  cbind(trainingSubjects, trainingValues, trainingActivity),
  cbind(testSubjects, testValues, testActivity)
)
rm(trainingSubjects, trainingValues, trainingActivity, 
   testSubjects, testValues, testActivity)
colnames(HActivity) <- c("subject", features[, 2], "activity")


columnsToKeep <- grepl("subject|activity|mean|std", colnames(HActivity))
HActivity <- HActivity[, columnsToKeep]

# replace activity values with factor levels
HActivity$activity <- factor(HActivity$activity, 
                                 levels = activities[, 1], labels = activities[, 2])

# get column names and remove special characters
HActivityCols <- colnames(HActivity)
HActivityCols <- gsub("[\\(\\)-]", "", HActivityCols)

# expand abbreviations 
HActivityCols <- gsub("^f", "frequencyDomain", HActivityCols)
HActivityCols <- gsub("^t", "timeDomain", HActivityCols)
HActivityCols <- gsub("Acc", "Accelerometer", HActivityCols)
HActivityCols <- gsub("Gyro", "Gyroscope", HActivityCols)
HActivityCols <- gsub("Mag", "Magnitude", HActivityCols)
HActivityCols <- gsub("Freq", "Frequency", HActivityCols)
HActivityCols <- gsub("mean", "Mean", HActivityCols)
HActivityCols <- gsub("std", "StandardDeviation", HActivityCols)
HActivityCols <- gsub("BodyBody", "Body", HActivityCols)
colnames(HActivity) <- HActivityCols

HActivityMeans <- HActivity %>% 
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

# output to file "TidyDataSet.txt"
write.table(HActivityMeans, "TidyDataSet.txt", row.names = FALSE, 
            quote = FALSE)
