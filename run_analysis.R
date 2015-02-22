## run_analysis.R does the following: 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average
##    of each variable for each activity and each subject.

## 1. Merge the training and the test sets to create one data set.

## (a) read in the data
activity_labels <- read.table("./data/getdata_project/UCI HAR Dataset/activity_labels.txt")
features <- read.table("./data/getdata_project/UCI HAR Dataset/features.txt")
subject_train <- read.table("./data/getdata_project/UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./data/getdata_project/UCI HAR Dataset/test/subject_test.txt")
y_train <- read.table("./data/getdata_project/UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("./data/getdata_project/UCI HAR Dataset/test/y_test.txt")
X_train <- read.table("./data/getdata_project/UCI HAR Dataset/train/X_train.txt")
X_test <- read.table("./data/getdata_project/UCI HAR Dataset/test/X_test.txt")

## (b) merge the Subject, X and Y data separately for Train and Test before combining
subject_train$id <- rownames(subject_train)
y_train$id <- rownames(y_train)
X_train$id <- rownames(X_train)
sub_y_train <- merge(subject_train,y_train,by="id")
sub_y_x_train <- merge(sub_y_train,X_train,by="id")

subject_test$id <- rownames(subject_test)
y_test$id <- rownames(y_test)
X_test$id <- rownames(X_test)
sub_y_test <- merge(subject_test,y_test,by="id")
sub_y_x_test <- merge(sub_y_test,X_test,by="id")

sub_y_x_all <- rbind(sub_y_x_train,sub_y_x_test)
sub_y_x_all <- subset(sub_y_x_all, select = -id )

## 2. Extract only the mean and standard deviation data 
means_and_stds <- features[c(grep('mean()',features$V2,fixed=TRUE),grep('std()',features$V2,fixed=TRUE)),]
means_and_stds <- means_and_stds[order(means_and_stds$V1),]
vars <- paste("V", means_and_stds[,"V1"], sep = "")
sub_y_x_ms <- sub_y_x_all[,c("V1.x", "V1.y", vars)]

## 3. Use descriptive variable names. 
varNames <- means_and_stds[,"V2"]
colnames(sub_y_x_ms) <- c("Subject","ActivityCode",as.character(varNames))

## 4. Use descriptive activity names for the activities
colnames(activity_labels) <- c("ActivityCode", "Activity")
sub_x_y_msa <- merge(sub_y_x_ms, activity_labels, by="ActivityCode")
sub_x_y_msa <- subset(sub_x_y_msa, select = -ActivityCode )
sub_x_y_msa <- sub_x_y_msa[,c("Subject","Activity",as.character(varNames))]

## 5. Create independent tidy data set with the average
##    of each variable for each activity and each subject.
library(dplyr)
grouped_data <- group_by(sub_x_y_msa,Activity,Subject)
tidy_data <- summarise_each(grouped_data, funs(mean))