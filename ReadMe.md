<h1> Read me </h1>

This is a ReadMe file for the final project of the Getting and Cleaning Data Course. It explaines how I obtained the "tidy data set with the average of each variable for each activity and each subject" demanded in the instructions. It incluses all the code from `run_analysis.R` with commentaries and explenations.

The "original data" referred to in this file represent data collected from the accelerometers from the Samsung Galaxy S smartphone. They can be found here:
  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The following code reads records with 561-feature vectors containing the data. It also labels the data set with descriptive variable names. For more info, see the `features_info.txt` file of the original data.

1. Test records

        test_X <- read.fwf( "UCI HAR Dataset/test/X_test.txt" , widths = rep(16, 561), header = F  )
        feature_names <-  read.csv("UCI HAR Dataset/features.txt", sep = " ", header = F,  stringsAsFactors = F )[,2] 
        colnames(test_X) <- feature_names

2. Train records

        train_X <- read.fwf( "UCI HAR Dataset/train/X_train.txt" , widths = rep(16, 561), header = F  )
        colnames(train_X) <- feature_names


The following code merges the test and train data and extracts only the measurements on the mean and standard deviation for each measurement. 

    merged_X <- rbind(test_X, train_X)
    merged_X$recordID <- 1:nrow(merged_X)
    merged_X <- merged_X[ , c("recordID", colnames(merged_X)[!colnames(merged_X) %in% "recordID"] ) ]
    merged_X <- merged_X[ c(1, grep( colnames(merged_X) , pattern = "mean" ) , grep( colnames(merged_X) , pattern = "std" ) ) ]
    merged_X <- merged_X[ - grep( colnames(merged_X) , pattern = "meanFreq" ) ]

The following code reads (meta)data with activity labels and identifiers of the subject who carried out the experiment. 

1. Test records

        test_activity <- read.csv("UCI HAR Dataset/test/Y_test.txt", sep = " ", header = F,  stringsAsFactors = F ) 
        test_subj <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep = " ", header = F,  stringsAsFactors = F ) 

2. Train records

        train_activity <- read.csv("UCI HAR Dataset/train/Y_train.txt", sep = " ", header = F,  stringsAsFactors = F ) 
        train_subj <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep = " ", header = F,  stringsAsFactors = F ) 

Merging the test and train data:

    merged_activity <- rbind( test_activity, train_activity )
    merged_subj <- rbind( test_subj, train_subj )


Adding a column (`recordID`) that allows to link these (meta)data and the main data:

    merged_activity <- cbind( merged_X$recordID, merged_activity )
    merged_subj <- cbind( merged_X$recordID, merged_subj )

    colnames(merged_activity) <- c("recordID", "acivityID")
    colnames(merged_subj) <- c("recordID","subjID")

Changing the activity code into descriptive activity names:

    merged_activity$label <- as.character(merged_activity$acivityID)
    merged_activity$label[ which(merged_activity$label=="1") ] <- "walking"
    merged_activity$label[ which(merged_activity$label=="2") ] <- "walkingUp"
    merged_activity$label[ which(merged_activity$label=="3") ] <- "walkingDown"
    merged_activity$label[ which(merged_activity$label=="4") ] <- "sitting"
    merged_activity$label[ which(merged_activity$label=="5") ] <- "standing"
    merged_activity$label[ which(merged_activity$label=="6") ] <- "laying"

Creating an independent tidy data set with the average of each variable for each activity and each subject:

    averaged <- merged_X[0, -1]
    averaged <- cbind( subjID = c(NA)[0], activityLabel = c(NA)[0], averaged  )
    averaged$subjID <- as.numeric(averaged$subjID); averaged$activityLabel <- as.character(averaged$activityLabel)
    i_row <- 0
    for ( i_subj in sort(unique(merged_subj$subjID)) ) {
      
      for ( i_act in unique(merged_activity$label) ) {
        
        i_row <- i_row + 1
        averaged[ i_row, "subjID" ] <- i_subj
        averaged[ i_row, "activityLabel" ] <- i_act
        
        i_avrgs <- apply( X = merged_X[ which( merged_X$recordID %in% merged_subj$recordID[ which( merged_subj$subjID == i_subj & merged_activity$label == i_act ) ] ) , -1 ] , 
                          MARGIN = 2, FUN = mean )
        
        averaged[ i_row, 3:68 ] <- i_avrgs
      }
    }

Writing to the file `averaged.txt`:

    write.table( averaged, "averaged.txt", row.names = F )




