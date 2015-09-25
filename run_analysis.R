
##Script for "Getting and CLeaning Data" course project
##You should create one R script called run_analysis.R that does the following. 
##Extracts only the measurements on the mean and standard deviation for each measurement. 
##Uses descriptive activity names to name the activities in the data set
##Appropriately labels the data set with descriptive variable names. 
##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Merge test and trianing set:
## Load the training data
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)

## Load the test data
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

# Row binds the train and test data
x_combined <- rbind(x_train, x_test)
y_combined <- rbind(y_train, y_test)
s_combined <- rbind(subject_train, subject_test)

## Extracts only the measurements on the mean and standard deviation for each measurement:
# create friendly feature labels
labels <- read.table("./UCI HAR Dataset/features.txt")
names(labels) <- c('feature_id', 'feature_name')
# Search for matches to argument mean or standard deviation (sd)  within each element of character vector
index_labels <- grep("-mean\\(\\)|-std\\(\\)", labels$feature_name) 
x_combined <- x_combined[, index_labels] 
# Replaces all matches of a string features 
names(x_combined) <- gsub("\\(|\\)", "", (labels[index_labels, 2]))

# Read activity labels
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
# Friendly names to activities column
names(activities) <- c('act_id', 'act_name')
y_combined[, 1] = activities[y_combined[, 1], 2]

names(y_combined) <- "Activity"
names(s_combined) <- "Subject"

# Create tiny dataset by combining data table by columns
tidyDataSet <- cbind(s_combined, y_combined, x_combined)

# Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject:
temp <- tidyDataSet[, 3:dim(tidyDataSet)[2]] 
tidyDataAVGSet <- aggregate(temp,list(tidyDataSet$Subject, tidyDataSet$Activity), mean)

# Activity and Subject name of columns 
names(tidyDataAVGSet)[1] <- "Subject"
names(tidyDataAVGSet)[2] <- "Activity"

# Write out files without row names
write.table(tidyDataSet, "tidyDataSetMean_Stddev.txt",row.names = FALSE)
write.table(tidyDataAVGSet, "tidyDataSet_Mean.txt", row.names = FALSE)