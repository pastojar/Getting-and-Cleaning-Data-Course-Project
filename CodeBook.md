<h1> Code Book </h1>

This is a Code Book for the data from the final project of the Getting and Cleaning Data Course The data represent "a tidy data set with the average of each variable for each activity and each subject". These data are saved in the `averaged.txt` file. This file can be loaded into R using

`
read.csv("averaged.txt", sep = " ")
`

The "original data" represent data collected from the accelerometers from the Samsung Galaxy S smartphone. They can be found here:
  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

A full description is available at the site where the data was obtained by the course orginizers:
  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones



<h2> Information about the variables </h2>
 
**subjID** - IDs of the test subjects (people) as defined in the `subject_test.txt` file of the original data.

**activityLabel** - self-explenatory activity labels as defined in the `activity_labels.txt` file of the original data.

***all other*** - averaged (the mean) variables from the original data for each activity and each subject. They are all normalized and bounded within [-1,1]. Detailed info about the variables can be found in the file `features_info.txt` of the original data. 


