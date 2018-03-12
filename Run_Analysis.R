library(reshape2)

filename <- "dataset.zip"

## If the data doesn't exist we will download it:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}


# Loading the activity labels and features
ActivityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
ActivityLabels[,2] <- as.character(ActivityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])



# Extracts only the measurements on the mean and standard deviation for each measurement.
Newfeatures <- grep(".*mean.*|.*std.*", features[,2])
Newfeatures.names <- features[Newfeatures,2]
Newfeatures.names = gsub('-mean', 'Mean', Newfeatures.names)
Newfeatures.names = gsub('-std', 'Std', Newfeatures.names)
Newfeatures.names <- gsub('[-()]', '', Newfeatures.names)


# Load the datasets from train dataset 
train <- read.table("UCI HAR Dataset/train/X_train.txt")[Newfeatures]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)


# Load the datasets from test dataset 
test <- read.table("UCI HAR Dataset/test/X_test.txt")[Newfeatures]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)


# Merges the training and the test sets to create one data set.
Data <- rbind(train, test)
colnames(Data) <- c("subject", "activity", Newfeatures.names)

Data$activity <- factor(Data$activity, levels = activityLabels[,1], labels = activityLabels[,2])
Data$subject <- as.factor(Data$subject)

Data.melted <- melt(Data, id = c("subject", "activity"))
Data.mean <- dcast(Data.melted, subject + activity ~ variable, mean)

write.table(Data.mean, "TidyDataSet.txt", row.names = FALSE, quote = FALSE)



