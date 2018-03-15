# Data Source
Data for this project was obtain from the Coursera assignment instructions. Data represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones]

Data for the project:

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip]

# Files

CodeBook.md describes the variables, the data, and any transformations or work that was performed to clean up the data.

run_analysis.R contains all the code to perform the analyses described in the 5 steps. 

The output of the 5th step is called averages_data.txt

# Creating the data set

The R script run_analysis.R can be used to create the data set. It retrieves the source data set and transforms it to produce the final data set by implementing the following steps (see the Code book for details, as well as the comments in the script itself):

 1- Download and unzip source data if it doesn't exist.
2- Read data.
3- Merge the training and the test sets to create one data set.
4- Extract only the measurements on the mean and standard deviation for each measurement.
5- Use descriptive activity names to name the activities in the data set.
6- Appropriately label the data set with descriptive variable names.
7- Create a second, independent tidy set with the average of each variable for each activity and each subject.
8- Write the data set to the tidy_data.txt file.

The tidy_dataset.txt in this repository was created by running the run_analysis.R script using R 
