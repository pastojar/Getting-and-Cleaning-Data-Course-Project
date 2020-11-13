
test_X <- read.fwf( "UCI HAR Dataset/test/X_test.txt" , widths = rep(16, 561), header = F  )
feature_names <-  read.csv("UCI HAR Dataset/features.txt", sep = " ", header = F,  stringsAsFactors = F )[,2] 
colnames(test_X) <- feature_names

train_X <- read.fwf( "UCI HAR Dataset/train/X_train.txt" , widths = rep(16, 561), header = F  )
colnames(train_X) <- feature_names

merged_X <- rbind(test_X, train_X)
merged_X$recordID <- 1:nrow(merged_X)
merged_X <- merged_X[ , c("recordID", colnames(merged_X)[!colnames(merged_X) %in% "recordID"] ) ]
merged_X <- merged_X[ c(1, grep( colnames(merged_X) , pattern = "mean" ) , grep( colnames(merged_X) , pattern = "std" ) ) ]
merged_X <- merged_X[ - grep( colnames(merged_X) , pattern = "meanFreq" ) ]


test_activity <- read.csv("UCI HAR Dataset/test/Y_test.txt", sep = " ", header = F,  stringsAsFactors = F ) 
test_subj <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep = " ", header = F,  stringsAsFactors = F ) 

train_activity <- read.csv("UCI HAR Dataset/train/Y_train.txt", sep = " ", header = F,  stringsAsFactors = F ) 
train_subj <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep = " ", header = F,  stringsAsFactors = F ) 

merged_activity <- rbind( test_activity, train_activity )
merged_subj <- rbind( test_subj, train_subj )

merged_activity <- cbind( merged_X$recordID, merged_activity )
merged_subj <- cbind( merged_X$recordID, merged_subj )

colnames(merged_activity) <- c("recordID", "acivityID")
colnames(merged_subj) <- c("recordID","subjID")

merged_activity$label <- as.character(merged_activity$acivityID)
merged_activity$label[ which(merged_activity$label=="1") ] <- "walking"
merged_activity$label[ which(merged_activity$label=="2") ] <- "walkingUp"
merged_activity$label[ which(merged_activity$label=="3") ] <- "walkingDown"
merged_activity$label[ which(merged_activity$label=="4") ] <- "sitting"
merged_activity$label[ which(merged_activity$label=="5") ] <- "standing"
merged_activity$label[ which(merged_activity$label=="6") ] <- "laying"



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

write.table( averaged, "averaged.txt", row.names = F )




