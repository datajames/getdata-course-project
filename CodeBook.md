Code Book for run_analysis
======================

This code book describes the data, variables and summarization for the run_analysis r script.

## Data

The data was downloaded from [this URL](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).  The data is based on the  ["Human Activity Recognition Using Smartphones" data set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

### The dataset includes the following files:

* ```'README.txt'```
* ```'features_info.txt'```: Shows information about the variables used on the feature vector.
* ```'features.txt'```: List of all features. (561 features)
* ```'activity_labels.txt'```: Links the class labels with their activity name. (Names and IDs for 6 activities)
* ```'train/X_train.txt'```: Training set. (7352 observations for 561 features)
* ```'train/y_train.txt'```: Training labels.
* ```'test/X_test.txt'```: Test set. (2947 observations for 561 features)
* ```'test/y_test.txt'```: Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

* ```'train/subject_train.txt'```: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
* ```'train/Inertial Signals/total_acc_x_train.txt'```: The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
* ```'train/Inertial Signals/body_acc_x_train.txt'```: The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

* 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

The Inertial Signals files were not used as part of this exercise.


## Variables

### Features in the orignal data set

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

* mean(): Mean value
* std(): Standard deviation
* mad(): Median absolute deviation 
* max(): Largest value in array
* min(): Smallest value in array
* sma(): Signal magnitude area
* energy(): Energy measure. Sum of the squares divided by the number of values. 
* iqr(): Interquartile range 
* entropy(): Signal entropy
* arCoeff(): Autorregresion coefficients with Burg order equal to 4
* correlation(): correlation coefficient between two signals
* maxInds(): index of the frequency component with largest magnitude
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency
* skewness(): skewness of the frequency domain signal 
* kurtosis(): kurtosis of the frequency domain signal 
* bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
* angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

* gravityMean
* tBodyAccMean
* tBodyAccJerkMean
* tBodyGyroMean
* tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'


### Data transformations

The following files were taken to create a complete data table:

* X_train.txt and X_test.txt were were bound together with a row bind
* features.txt was used to provide the column names for this new data table
* only columns that contained mean or std were kept, the rest were dropped

* y_train.txt and y_test.txt were bound together with a row bind, giving a column with all of the activity IDs
* the activity_labels.txt file was loaded into a data.frame and joined onto the data frame with all activities carried out.  The result of this is the addition of a human readable activity label against each activityID

* this new data frame was then added onto the main data table
* the same procedure was used to add the subject information to the main data table


The original column names had some shorthand notation for some of the variables:

* t - denotes time
* f - denotes frequency
* Acc - denotes Accelerometer
* Mag - denotes Magnitude
* Gyro - denotes Gyroscope

The following transformations were made on the original column names to make them more human readable:

```
columnNames = names(allObs)
columnNames <- gsub(pattern="^t",replacement="time",x=columnNames)
columnNames <- gsub(pattern="^f",replacement="frequency",x=columnNames)
columnNames <- gsub(pattern="Acc",replacement="Accelerometer",x=columnNames)
columnNames <- gsub(pattern="Mag",replacement="Magnitude",x=columnNames)
columnNames <- gsub(pattern="Gyro",replacement="Gyroscope",x=columnNames)
colnames(allObs) <- columnNames
```

## Summarising Data

A final data tidy data set was produced based on an aggregation by two features; subjectid and actvity.  This showed the mean for the data for each subject by activity type.  The factors for the activity type were:

* WALKING            
* WALKING_UPSTAIRS
* WALKING_DOWNSTAIRS
* SITTING  
* STANDING         
* LAYING

The following code was used to make the table structure below:

```
# use melt {reshape2} to stretch by the subjectid and activityLabel
newDataSet <- melt(allObs,id.vars = c("subjectid","activityLabel"))

# then aggregate and run the mean function by subjectid and the activity label
newDataSet <- dcast(newDataSet,subjectid+activityLabel ~ variable, fun.aggregate=mean)

# this gives our new independed data set with summary information for each varilable for each activity and subject
write.table(newDataSet, './tidy_dataset.txt',row.names=TRUE,sep='\t');

```

| column       | description                                              | type    |
| ------------ | -------------------------------------------------------- | ------- |
| subjectid     | Unique ID for the subject                              | int    |
| activityLabel     | Human readable label for the activity                                   | factor  |
| ... (other columns) ...  | Mean of all samples by subject and activity | num |


The final tidy set produced by the code and outputted as a tab delimited txt file  has the following structure 

```

> str(newDataSet)
'data.frame':  180 obs. of  81 variables:
 $ subjectid                                             : int  1 1 1 1 1 1 2 2 2 2 ...
 $ activityLabel                                         : Factor w/ 6 levels "LAYING","SITTING",..: 1 2 3 4 5 6 1 2 3 4 ...
 $ timeBodyAccelerometer-mean()-X                        : num  0.222 0.261 0.279 0.277 0.289 ...
 $ timeBodyAccelerometer-mean()-Y                        : num  -0.04051 -0.00131 -0.01614 -0.01738 -0.00992 ...
 $ timeBodyAccelerometer-mean()-Z                        : num  -0.113 -0.105 -0.111 -0.111 -0.108 ...
 $ timeBodyAccelerometer-std()-X                         : num  -0.928 -0.977 -0.996 -0.284 0.03 ...
 $ timeBodyAccelerometer-std()-Y                         : num  -0.8368 -0.9226 -0.9732 0.1145 -0.0319 ...
 $ timeBodyAccelerometer-std()-Z                         : num  -0.826 -0.94 -0.98 -0.26 -0.23 ...
 $ timeGravityAccelerometer-mean()-X                     : num  -0.249 0.832 0.943 0.935 0.932 ...
 $ timeGravityAccelerometer-mean()-Y                     : num  0.706 0.204 -0.273 -0.282 -0.267 ...
 $ timeGravityAccelerometer-mean()-Z                     : num  0.4458 0.332 0.0135 -0.0681 -0.0621 ...
 $ timeGravityAccelerometer-std()-X                      : num  -0.897 -0.968 -0.994 -0.977 -0.951 ...
 $ timeGravityAccelerometer-std()-Y                      : num  -0.908 -0.936 -0.981 -0.971 -0.937 ...
 $ timeGravityAccelerometer-std()-Z                      : num  -0.852 -0.949 -0.976 -0.948 -0.896 ...
 $ timeBodyAccelerometerJerk-mean()-X                    : num  0.0811 0.0775 0.0754 0.074 0.0542 ...
 $ timeBodyAccelerometerJerk-mean()-Y                    : num  0.003838 -0.000619 0.007976 0.028272 0.02965 ...
 $ timeBodyAccelerometerJerk-mean()-Z                    : num  0.01083 -0.00337 -0.00369 -0.00417 -0.01097 ...
 $ timeBodyAccelerometerJerk-std()-X                     : num  -0.9585 -0.9864 -0.9946 -0.1136 -0.0123 ...
 $ timeBodyAccelerometerJerk-std()-Y                     : num  -0.924 -0.981 -0.986 0.067 -0.102 ...
 $ timeBodyAccelerometerJerk-std()-Z                     : num  -0.955 -0.988 -0.992 -0.503 -0.346 ...
 $ timeBodyGyroscope-mean()-X                            : num  -0.0166 -0.0454 -0.024 -0.0418 -0.0351 ...
 $ timeBodyGyroscope-mean()-Y                            : num  -0.0645 -0.0919 -0.0594 -0.0695 -0.0909 ...
 $ timeBodyGyroscope-mean()-Z                            : num  0.1487 0.0629 0.0748 0.0849 0.0901 ...
 $ timeBodyGyroscope-std()-X                             : num  -0.874 -0.977 -0.987 -0.474 -0.458 ...
 $ timeBodyGyroscope-std()-Y                             : num  -0.9511 -0.9665 -0.9877 -0.0546 -0.1263 ...
 $ timeBodyGyroscope-std()-Z                             : num  -0.908 -0.941 -0.981 -0.344 -0.125 ...
 $ timeBodyGyroscopeJerk-mean()-X                        : num  -0.1073 -0.0937 -0.0996 -0.09 -0.074 ...
 $ timeBodyGyroscopeJerk-mean()-Y                        : num  -0.0415 -0.0402 -0.0441 -0.0398 -0.044 ...
 $ timeBodyGyroscopeJerk-mean()-Z                        : num  -0.0741 -0.0467 -0.049 -0.0461 -0.027 ...
 $ timeBodyGyroscopeJerk-std()-X                         : num  -0.919 -0.992 -0.993 -0.207 -0.487 ...
 $ timeBodyGyroscopeJerk-std()-Y                         : num  -0.968 -0.99 -0.995 -0.304 -0.239 ...
 $ timeBodyGyroscopeJerk-std()-Z                         : num  -0.958 -0.988 -0.992 -0.404 -0.269 ...
 $ timeBodyAccelerometerMagnitude-mean()                 : num  -0.8419 -0.9485 -0.9843 -0.137 0.0272 ...
 $ timeBodyAccelerometerMagnitude-std()                  : num  -0.7951 -0.9271 -0.9819 -0.2197 0.0199 ...
 $ timeGravityAccelerometerMagnitude-mean()              : num  -0.8419 -0.9485 -0.9843 -0.137 0.0272 ...
 $ timeGravityAccelerometerMagnitude-std()               : num  -0.7951 -0.9271 -0.9819 -0.2197 0.0199 ...
 $ timeBodyAccelerometerJerkMagnitude-mean()             : num  -0.9544 -0.9874 -0.9924 -0.1414 -0.0894 ...
 $ timeBodyAccelerometerJerkMagnitude-std()              : num  -0.9282 -0.9841 -0.9931 -0.0745 -0.0258 ...
 $ timeBodyGyroscopeMagnitude-mean()                     : num  -0.8748 -0.9309 -0.9765 -0.161 -0.0757 ...
 $ timeBodyGyroscopeMagnitude-std()                      : num  -0.819 -0.935 -0.979 -0.187 -0.226 ...
 $ timeBodyGyroscopeJerkMagnitude-mean()                 : num  -0.963 -0.992 -0.995 -0.299 -0.295 ...
 $ timeBodyGyroscopeJerkMagnitude-std()                  : num  -0.936 -0.988 -0.995 -0.325 -0.307 ...
 $ frequencyBodyAccelerometer-mean()-X                   : num  -0.9391 -0.9796 -0.9952 -0.2028 0.0382 ...
 $ frequencyBodyAccelerometer-mean()-Y                   : num  -0.86707 -0.94408 -0.97707 0.08971 0.00155 ...
 $ frequencyBodyAccelerometer-mean()-Z                   : num  -0.883 -0.959 -0.985 -0.332 -0.226 ...
 $ frequencyBodyAccelerometer-std()-X                    : num  -0.9244 -0.9764 -0.996 -0.3191 0.0243 ...
 $ frequencyBodyAccelerometer-std()-Y                    : num  -0.834 -0.917 -0.972 0.056 -0.113 ...
 $ frequencyBodyAccelerometer-std()-Z                    : num  -0.813 -0.934 -0.978 -0.28 -0.298 ...
 $ frequencyBodyAccelerometer-meanFreq()-X               : num  -0.1588 -0.0495 0.0865 -0.2075 -0.3074 ...
 $ frequencyBodyAccelerometer-meanFreq()-Y               : num  0.0975 0.0759 0.1175 0.1131 0.0632 ...
 $ frequencyBodyAccelerometer-meanFreq()-Z               : num  0.0894 0.2388 0.2449 0.0497 0.2943 ...
 $ frequencyBodyAccelerometerJerk-mean()-X               : num  -0.9571 -0.9866 -0.9946 -0.1705 -0.0277 ...
 $ frequencyBodyAccelerometerJerk-mean()-Y               : num  -0.9225 -0.9816 -0.9854 -0.0352 -0.1287 ...
 $ frequencyBodyAccelerometerJerk-mean()-Z               : num  -0.948 -0.986 -0.991 -0.469 -0.288 ...
 $ frequencyBodyAccelerometerJerk-std()-X                : num  -0.9642 -0.9875 -0.9951 -0.1336 -0.0863 ...
 $ frequencyBodyAccelerometerJerk-std()-Y                : num  -0.932 -0.983 -0.987 0.107 -0.135 ...
 $ frequencyBodyAccelerometerJerk-std()-Z                : num  -0.961 -0.988 -0.992 -0.535 -0.402 ...
 $ frequencyBodyAccelerometerJerk-meanFreq()-X           : num  0.132 0.257 0.314 -0.209 -0.253 ...
 $ frequencyBodyAccelerometerJerk-meanFreq()-Y           : num  0.0245 0.0475 0.0392 -0.3862 -0.3376 ...
 $ frequencyBodyAccelerometerJerk-meanFreq()-Z           : num  0.02439 0.09239 0.13858 -0.18553 0.00937 ...
 $ frequencyBodyGyroscope-mean()-X                       : num  -0.85 -0.976 -0.986 -0.339 -0.352 ...
 $ frequencyBodyGyroscope-mean()-Y                       : num  -0.9522 -0.9758 -0.989 -0.1031 -0.0557 ...
 $ frequencyBodyGyroscope-mean()-Z                       : num  -0.9093 -0.9513 -0.9808 -0.2559 -0.0319 ...
 $ frequencyBodyGyroscope-std()-X                        : num  -0.882 -0.978 -0.987 -0.517 -0.495 ...
 $ frequencyBodyGyroscope-std()-Y                        : num  -0.9512 -0.9623 -0.9871 -0.0335 -0.1814 ...
 $ frequencyBodyGyroscope-std()-Z                        : num  -0.917 -0.944 -0.982 -0.437 -0.238 ...
 $ frequencyBodyGyroscope-meanFreq()-X                   : num  -0.00355 0.18915 -0.12029 0.01478 -0.10045 ...
 $ frequencyBodyGyroscope-meanFreq()-Y                   : num  -0.0915 0.0631 -0.0447 -0.0658 0.0826 ...
 $ frequencyBodyGyroscope-meanFreq()-Z                   : num  0.010458 -0.029784 0.100608 0.000773 -0.075676 ...
 $ frequencyBodyAccelerometerMagnitude-mean()            : num  -0.8618 -0.9478 -0.9854 -0.1286 0.0966 ...
 $ frequencyBodyAccelerometerMagnitude-std()             : num  -0.798 -0.928 -0.982 -0.398 -0.187 ...
 $ frequencyBodyAccelerometerMagnitude-meanFreq()        : num  0.0864 0.2367 0.2846 0.1906 0.1192 ...
 $ frequencyBodyBodyAccelerometerJerkMagnitude-mean()    : num  -0.9333 -0.9853 -0.9925 -0.0571 0.0262 ...
 $ frequencyBodyBodyAccelerometerJerkMagnitude-std()     : num  -0.922 -0.982 -0.993 -0.103 -0.104 ...
 $ frequencyBodyBodyAccelerometerJerkMagnitude-meanFreq(): num  0.2664 0.3519 0.4222 0.0938 0.0765 ...
 $ frequencyBodyBodyGyroscopeMagnitude-mean()            : num  -0.862 -0.958 -0.985 -0.199 -0.186 ...
 $ frequencyBodyBodyGyroscopeMagnitude-std()             : num  -0.824 -0.932 -0.978 -0.321 -0.398 ...
 $ frequencyBodyBodyGyroscopeMagnitude-meanFreq()        : num  -0.139775 -0.000262 -0.028606 0.268844 0.349614 ...
 $ frequencyBodyBodyGyroscopeJerkMagnitude-mean()        : num  -0.942 -0.99 -0.995 -0.319 -0.282 ...
 $ frequencyBodyBodyGyroscopeJerkMagnitude-std()         : num  -0.933 -0.987 -0.995 -0.382 -0.392 ...
 $ frequencyBodyBodyGyroscopeJerkMagnitude-meanFreq()    : num  0.176 0.185 0.334 0.191 0.19 ...

```