# Make sure that the workspace is clean
rm(list=ls())

require(plyr)
require(reshape2)

# get the data file and unzip it, although first check to see if it is already there

#Check to see if the file already exists, if it does not download it
if (!file.exists("./getdata-projectfiles-UCI HAR Dataset.zip")) {
  fileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  download.file(fileURL, destfile='./getdata-projectfiles-UCI HAR Dataset.zip', method = 'curl')
  unzip('./getdata-projectfiles-UCI HAR Dataset.zip')
}

# 1. Merge the training and the test sets to create one data set

## load X test data abnd bind together, then add the feature names
testSet <- read.table("./UCI HAR Dataset/test/X_test.txt")
trainSet <- read.table("./UCI HAR Dataset/train/X_train.txt")
allObs <- rbind(testSet,trainSet)

# 2. Extract only the measurements on the mean and standard deviation for each measurement

## load the feature names and add as the colnames
features <- read.table("./UCI HAR Dataset/features.txt",stringsAsFactors=FALSE)[[2]]
colnames(allObs) <- features

## use these to grep for the required fields
allObs<- allObs[,grep("mean|std",features)]

# 3. Use descriptive activity names to name the activities in the data set

## load the activity names
activity_names <- read.table("./UCI HAR Dataset/activity_labels.txt",stringsAsFactors=FALSE)
colnames(activity_names) <- c("activityID","activityLabel")

## load the activity column for both the training and test set
## make sure that they are loaded in the same order
testActivitySet <- read.table("./UCI HAR Dataset/test/y_test.txt")
trainActivitySet <- read.table("./UCI HAR Dataset/train/y_train.txt")
allActivityObs <- rbind(testActivitySet,trainActivitySet)

## give the allActivityObs the same colname as the activity_names id, i.e. activityID
colnames(allActivityObs) <- c("activityID")

## use the activity_labels to join (from plyr) onto the allActivityObs 
#sum(sort(unique(allActivityObs$activityID)) == sort(unique(activity_labels$activityID))) == length(unique(activity_labels$activityID))
allActivityObs <- join(allActivityObs,activity_names,by = "activityID")


## add an activity column to the main data set
## replace the activityid with a descriptive name from the activity names list
## this is done by taking the new activityLabel column for allActivityObs
allObs <- cbind(allObs,activityLabel=allActivityObs$activityLabel)

# 4. Appropriately label the data with descriptive variable names

# t - denotes time
# f - denotes frequency
# Acc - denotes Accelerometer
# Mag - denotes Magnitude
# Gyro - denotes Gyroscope

columnNames = names(allObs)
columnNames <- gsub(pattern="^t",replacement="time",x=columnNames)
columnNames <- gsub(pattern="^f",replacement="frequency",x=columnNames)
columnNames <- gsub(pattern="Acc",replacement="Accelerometer",x=columnNames)
columnNames <- gsub(pattern="Mag",replacement="Magnitude",x=columnNames)
columnNames <- gsub(pattern="Gyro",replacement="Gyroscope",x=columnNames)
colnames(allObs) <- columnNames

# 5. From the table in step 4, create a second, independent tidy data set with the 
# arrays of each variable for each activity and subject 

## we will need to add the subjectid to the main data table before we can create the independent data set
testSubjectSet <- read.table("./UCI HAR Dataset/test/subject_test.txt")
trainSubjectSet <- read.table("./UCI HAR Dataset/train/subject_train.txt")
allSubjectObs <- rbind(testSubjectSet,trainSubjectSet)
colnames(allSubjectObs) <- c("subjectID")
allObs <- cbind(allObs,subjectid=allSubjectObs$subjectID)

# use melt {reshape2} to stretch by the subjectid and activityLabel
newDataSet <- melt(allObs,id.vars = c("subjectid","activityLabel"))

# then aggregate and run the mean function by subjectid and the activity label
newDataSet <- dcast(newDataSet,subjectid+activityLabel ~ variable, fun.aggregate=mean)

# this gives our new independed data set with summary information for each varilable for each activity and subject
write.table(newDataSet, './tidy_dataset.txt',row.names=TRUE,sep='\t');
