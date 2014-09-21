library(plyr)
library(dplyr) 

################################################################################################################################################
#
# will use the ddply from the plyr library to re-arrange columns and summerize colums - mean and standard deviation
# by subject per activity
#
################################################################################################################################################

LoadActivityLabels <- function () {
  
  # get the activity labels
  
  # activity_labels
  # 1 WALKING
  # 2 WALKING_UPSTAIRS
  # 3 WALKING_DOWNSTAIRS
  # 4 SITTING
  # 5 STANDING
  # 6 LAYING
  
  #the colClasses=c("NULL", "character") get rid of the first column that has 
  #numnbers in it. so we get a vector of activity names only.
  
  activity_labels_df<-
    read.table("activity_labels.txt", 
               sep = "", 
               colClasses=c("NULL", "character"), 
               header = FALSE , stringsAsFactors= FALSE)
  
  colnames(activity_labels_df) <- c("Activity")
  return (activity_labels_df)
}

LoadFeatures <- function() {
  
  # get the column names from the features.txt 
  # the tBodyAcc-mean()-X  tBodyAcc-mean()-Y  tBodyAcc-mean()-Z	tBodyAcc-std()-X	
  # tBodyAcc-std()-Y	tBodyAcc-std(), etc..
  
  features_df<-
    read.table("features.txt", 
               header = FALSE , 
               colClasses=c("NULL", "character"), 
               stringsAsFactors= FALSE)
  return (features_df)
}

LoadTrainingDataSet <- function() {
  
  #loads the x_train dataset
  X_train_raw_df<-
    read.table("train\\X_train.txt", 
               header = FALSE , 
               stringsAsFactors= FALSE)
  return (X_train_raw_df)
}


LoadSubjectTrainingDataSet <- function() {
  
  #get the subject list for the training data set
  
  train_subject_list_df<-
    read.table("train\\subject_train.txt", 
               header = FALSE , 
               stringsAsFactors= FALSE)
  
  colnames(train_subject_list_df) <- c("Subject")
  return (train_subject_list_df)
}

LoadTestDataSet <- function() {
  
  #loads the x_test dataset
  X_test_raw_df<-
    read.table("test\\X_test.txt", 
               header = FALSE , 
               stringsAsFactors= FALSE)
  
  return (X_test_raw_df)
}

LoadSubjectTestDataSet <- function() {
  
  #get the subject list for the test data set
  
  test_subject_list_df<-
    read.table("test\\subject_test.txt", 
               header = FALSE , 
               stringsAsFactors= FALSE)
  colnames(test_subject_list_df) <- c("Subject")
  
  return (test_subject_list_df)
}


CreateDataSetWithSubjectFeatures <- function(raw_df, features_df, subject_df) {
  
  #features_df is a column so need to transpose to row to use the colnames
  colnames(raw_df) <- t(features_df)
  
  #bind the test subjects column 
  Subject_Features_df<- cbind(raw_df, subject_df)
  return (Subject_Features_df)
}

CreateActivityColumn <- function (activity_labels_df, subject_list_df){
  
  #creats the activity column from apppropriate subject_list
  #create activity list 1-6 [WALKING to LAYING] then back to 1 loop over.  When the trainig subject changes
  #the activity strats to 1 [WALKING] again
  
  activity_column <- NULL
  old_subject <-subject_list_df[1,]
  activity_index <- 1
  
  for(i in seq(1, nrow(subject_list_df)))
  {
    if (activity_index > 6)
      activity_index=1
    
    new_subject=subject_list_df[i,]
    
    if (old_subject == new_subject)
    {
      activity_column <- rbind(activity_column, activity_labels_df[activity_index,])
    }
    else
    {
      old_subject = new_subject
      activity_column <- rbind(activity_column, activity_labels_df[1,])
      activity_index <- 1
    }
    activity_index = activity_index + 1
  }
  colnames(activity_column)<-c("Activity")
  return (activity_column)
}

###############################################################################################################################################
#
# The functions defined above are used to complete the assignment
#
###############################################################################################################################################

#load common datasets - activities and features [labels]
activity_labels_df      <- LoadActivityLabels()
features_df             <- LoadFeatures()

#test dataset
training_raw_df         <- LoadTrainingDataSet()
training_subject_df     <- LoadSubjectTrainingDataSet()
training_subject_features_df <- CreateDataSetWithSubjectFeatures(training_raw_df, features_df, training_subject_df)
activity_column_training     <- CreateActivityColumn(activity_labels_df, training_subject_df)

#bind the activity column to get a properly labeled training dataset
training_with_subject_activity_features_df<- cbind(training_subject_features_df, activity_column_training)

##Now for the test dataset
test_raw_df             <- LoadTestDataSet()
test_subject_df         <- LoadSubjectTestDataSet()
test_subject_features_df <- CreateDataSetWithSubjectFeatures(test_raw_df, features_df, test_subject_df)
activity_column_test   <- CreateActivityColumn(activity_labels_df, test_subject_df)

#bind the activity column to get a properly labeled test dataset
test_with_subject_activity_features_df<- cbind(test_subject_features_df, activity_column_test)

#################################################################################################################################################
#
#   Answer to 1. Merges the training and the test sets to create one data set.
#               The new dataset is called - merged_training_test_df
#
################################################################################################################################################

merged_training_test_df <- rbind(training_with_subject_activity_features_df, test_with_subject_activity_features_df) 

################################################################################################################################################
#
#   Answet to 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#
#
#   we need the following columns [X] -> column index in data frame
#   [562]Subject, [563]Activity, [1]tBodyAcc-mean()-X, [2]tBodyAcc-mean()-Y, [3]tBodyAcc-mean()-Z, [4]tBodyAcc-std()-X, [5]tBodyAcc-std()-Y, [6]tBodyAcc-std()-Z
#   The plyr library is used with the arrange and select functions must use the ` for the column names
#
#   Output : head(mean_standardDeviation_each_measurement_df)
#
#  Subject           Activity tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X tBodyAcc-std()-Y tBodyAcc-std()-Z
#       1            WALKING         0.2885845       -0.02029417        -0.1329051       -0.9952786       -0.9831106       -0.9135264
#       1   WALKING_UPSTAIRS         0.2784188       -0.01641057        -0.1235202       -0.9982453       -0.9753002       -0.9603220
#       1 WALKING_DOWNSTAIRS         0.2796531       -0.01946716        -0.1134617       -0.9953796       -0.9671870       -0.9789440
#       ...
#       ...
#
################################################################################################################################################


mean_standardDeviation_each_measurement_df <- select(merged_training_test_df, 
                                                     Subject, 
                                                     Activity, 
                                                     `tBodyAcc-mean()-X`, 
                                                     `tBodyAcc-mean()-Y`, 
                                                     `tBodyAcc-mean()-Z`, 
                                                     `tBodyAcc-std()-X`, 
                                                     `tBodyAcc-std()-Y`, 
                                                     `tBodyAcc-std()-Z`)

################################################################################################################################################
#
#
#   Answer to 3. Uses descriptive activity names to name the activities in the data set
#
#   Column activities 
#   DONE ALREADY above by the functions
#
#   activity_column_training     <- CreateActivityColumn(activity_labels_df, training_subject_df)
#
#   bind the activity column to get a properly labeled training dataset
#
#   training_with_subject_activity_features_df<- cbind(training_subject_features_df, activity_column_training)
#
#   activity_column_test   <- CreateActivityColumn(activity_labels_df, test_subject_df)
#
#   #bind the activity column to get a properly labeled test dataset
#   test_with_subject_activity_features_df<- cbind(test_subject_features_df, activity_column_test)
#
#
#   mean_standardDeviation_each_measurement_df
#
#
# Subject           Activity tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X tBodyAcc-std()-Y tBodyAcc-std()-Z
#       1            WALKING         0.2885845       -0.02029417        -0.1329051       -0.9952786       -0.9831106       -0.9135264
#       1   WALKING_UPSTAIRS         0.2784188       -0.01641057        -0.1235202       -0.9982453       -0.9753002       -0.9603220
#       1 WALKING_DOWNSTAIRS         0.2796531       -0.01946716        -0.1134617       -0.9953796       -0.9671870       -0.9789440
#
#
###############################################################################################################################################


################################################################################################################################################
#
#
#   Answer to 4. Appropriately labels the data set with descriptive variable names. 
#   
#   Current we have : 
#   Subject Activity tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X tBodyAcc-std()-Y tBodyAcc-std()-Z
#
#     Coulmn             Renamed to 
#     tBodyAcc-mean()-X  BodyAcc_mean_X
#     tBodyAcc-mean()-Y  BodyAcc_mean_Y
#     tBodyAcc_mean()-Z  BodyAcc_mean_Z
#     tBodyAcc-std()-X   BodyAcc_std_X
#     tBodyAcc-std()-Y   BodyAcc_std_Y
#     tBodyAcc-std()-Z   BodyAcc_std()_Z
#
#  Output head(mean_standardDeviation_each_measurement_df)
#  Subject           Activity BodyAcc_mean_X BodyAcc_mean_Y BodyAcc_mean_Z BodyAcc_std_X BodyAcc_std_Y BodyAcc_std_Z
#       1            WALKING      0.2885845    -0.02029417     -0.1329051    -0.9952786    -0.9831106    -0.9135264
#       1   WALKING_UPSTAIRS      0.2784188    -0.01641057     -0.1235202    -0.9982453    -0.9753002    -0.9603220
#       1 WALKING_DOWNSTAIRS      0.2796531    -0.01946716     -0.1134617    -0.9953796    -0.9671870    -0.9789440
#     ..
#     ..
#
###############################################################################################################################################

colnames(mean_standardDeviation_each_measurement_df) <- c("Subject", "Activity","BodyAcc_mean_X", "BodyAcc_mean_Y", "BodyAcc_mean_Z", 
                                                          "BodyAcc_std_X","BodyAcc_std_Y","BodyAcc_std_Z")


################################################################################################################################################
#
#
#   Answer to 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
#
#   we use the ddply summerize function calc the mean, and sd for each activity of the subjects
#
#   subject Activity       Mean_BodyAcc_X Mean_BodyAcc_Y Mean_BodyAcc_Z SD_BodyAcc_X SD_BodyAcc_Y SD_BodyAcc_Z
#	  1	      LAYING	              0.2648335	-0.029303041	-0.10242910	0.3887721	0.5261963	0.4031333
#	  1	      SITTING	              0.2777755	-0.009454327	-0.12446309	0.3979940	0.4984745	0.3949040
#	  1	      STANDING	            0.2509040	-0.017586504	-0.10975717	0.3915039	0.5056613	0.4020185
#	  1	      WALKING	              0.2669169	-0.027559034	-0.10211377	0.3913241	0.5131385	0.3882607
#	  1	      WALKING_DOWNSTAIRS	  0.2729630	-0.010070896	-0.10759135	0.4049034	0.5083213	0.3979344
#	  1	      WALKING_UPSTAIRS	    0.2607737	-0.016004972	-0.10062653	0.3981139	0.5041289	0.3935471
#	  2	      LAYING	              0.2610407	-0.020139879	-0.12089982	0.4121243	0.5420975	0.4214406
#	  2	      SITTING	              0.2740099 -0.018661783	-0.11164544	0.3855768	0.5511862	0.3973843
#	  2	      STANDING	            0.2715503	 -0.017156987	-0.11765357	0.4052940	0.5562694	0.4176617
#	  2	      WALKING	              0.2713004	 -0.022699341 -0.11114372	0.4179892	0.5491988	0.4142691
#	  2       WALKING_DOWNSTAIRS	0.2832137	-0.019380744	-0.11719920	0.4075866	0.5417765	0.3830012
#	  2	      WALKING_UPSTAIRS	  0.2775120	-0.016731845	-0.11545208	0.4021917	0.5347908	0.3991728
#   ...
#   ...
#   ...
#   ...
#   29	WALKING_UPSTAIRS	    0.2683911	-0.017868992	-0.10210131	0.4886443	0.4390570	0.4330459
#	  30	LAYING	              0.2694957	-0.016692834	-0.10648124	0.3854047	0.4317325	0.4456993
#   30	SITTING	              0.2859146	-0.022973287	-0.10338805	0.3796512	0.4145895	0.4438154
#	  30	STANDING	            0.2728194	-0.015329922	-0.11277526	0.3960901	0.4448437	0.4448590
#	  30	WALKING	              0.2802624	-0.016357771	-0.12001916	0.3735528	0.4211396	0.4448913
#	  30	WALKING_DOWNSTAIRS	  0.2791828	-0.018649982	-0.08886951	0.3934784	0.4218494	0.4329473
#	  30	WALKING_UPSTAIRS	    0.2700537	-0.015495901	-0.10383732	0.3932059	0.4255383	0.4318944
#   
#     tidy_dataset
#
################################################################################################################################################

tidy_dataset <-ddply(mean_standardDeviation_each_measurement_df, 
                      c("Subject", "Activity"), summarise,
                      Mean_BodyAcc_X = mean(BodyAcc_mean_X),
                      Mean_BodyAcc_Y = mean(BodyAcc_mean_Y),
                      Mean_BodyAcc_Z = mean(BodyAcc_mean_Z),
                      SD_BodyAcc_X = sd(BodyAcc_std_X),
                      SD_BodyAcc_Y = sd(BodyAcc_std_Y),
                      SD_BodyAcc_Z = sd(BodyAcc_std_Z)
                    )

################################################################################################################################################
#
#   Save dataset to file named : TidyDataSet.txt  
#
################################################################################################################################################


write.table(tidy_dataset, file = "TidyDataSet.txt",row.names=FALSE)


################################################################################################################################################
#   End of Assignment. We have out tidy_dataset :)
################################################################################################################################################
