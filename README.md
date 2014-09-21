Readme

The run_analysis.R file uses the plyr and dplyr libraries in the end to select the relevant columns and sumerize their content per subject per activity.

The  code is self documented and looks better with the comments so better refer to the raun_analysis.R file

It is made up of the following functions:

<b>LoadActivityLabels</b>
This function loads the 6 activities, namely : WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING and LAYING from the activity_labels.txt.  It returns a one column dataset.  The ladel for that column is Activity.

<b>LoadFeatures</b>
This function loads the features for the test and train dataset.  There are 561 rows in the file features.txt.  This is used to label the train and test dataset columns.

<b>LoadTrainingDataSet</b>
This function loads the training dataset from the file <i>train\\X_train.txt</i>. 

<b>LoadTestDataSet</b>
This function loads the training dataset from the file <i>train\\X_test.txt</i>. 

<b>LoadSubjectTestDataSet</b>
This function loads the subject column for the test dataset.  It contains 2947 observations.  

<b>LoadSubjectTrainDataSet</b>
This function loads the subject column for the training dataset.  It contains 7352 observations.  

<b>CreateDataSetWithSubjectFeatures(raw_df, features_df, subject_df)</b>
This function takes either the training or the test dataset and properly adds the column labels which were obtained from the features dataset. It also appends the subject performing the activities at the end of the resulting dataframe.

<b>CreateActivityColumn(activity_labels_df, subject_list_df)</b>
This function creats an activity column for the subject.  The activities are 1 to 6 1 WALKING, 2 WALKING_UPSTAIRS, 3 WALKING_DOWNSTAIRS, 4 SITTING, 5 STANDING and 6 LAYING.

We have a long row of subjects labelled 1-30 split over in the 2 dataset, the taining and the test dataset.
as long as the subjec is the same, it will sequentially add the activites 1 though 6.  when it reaches 6 it will start again at 1.
If the subject changes from say 2 to 3, it will start over at activity 1 for subject 3.  
Eg. last activity for subject 2 is say WALKING_UPSTAIRS, logically the next activity should be WALKING_DOWNSTAIRS, but since the subject changed to 3, the first activity of subject 3 will be WALKING.


<i>load common datasets - activities and features [labels]</i>
<b>activity_labels_df &nbsp; <- LoadActivityLabels()<br/>
features_df&nbsp;&nbsp;      <- LoadFeatures()</b>

<i>load the training dataset</i><br/>
<b>training_raw_df &nbsp;&nbsp; <- LoadTrainingDataSet()<br/>
training_subject_df&nbsp;<- LoadSubjectTrainingDataSet()<br/>
training_subject_features_df&nbsp;<- CreateDataSetWithSubjectFeatures(training_raw_df, features_df, training_subject_df)<br/>
activity_column_training &nbsp;<- CreateActivityColumn(activity_labels_df, training_subject_df)</b><br/>

<i>bind the activity column to get a properly labeled training dataset</i><br/>
<b>training_with_subject_activity_features_df<- cbind(training_subject_features_df, activity_column_training)</b><br />

<i>Now for the test dataset</i><br/>
<b>test_raw_df &nbsp;&nbsp;<- LoadTestDataSet()<br/>
test_subject_df &nbsp;&nbsp; <- LoadSubjectTestDataSet()<br/>
test_subject_features_df <- CreateDataSetWithSubjectFeatures(test_raw_df, features_df, test_subject_df)<br/>
activity_column_test &nbsp <- CreateActivityColumn(activity_labels_df, test_subject_df)</b><br/>

<i>bind the activity column to get a properly labeled test dataset</i><br/>
<b>test_with_subject_activity_features_df<- cbind(test_subject_features_df, activity_column_test)</b><br/>

<i>Now for the test dataset</i><br/>
<b>test_raw_df &nbsp;&nbsp;<- LoadTestDataSet()<br/>
test_subject_df  &nbsp;<- LoadSubjectTestDataSet()<br/>
test_subject_features_df&nbsp; <- CreateDataSetWithSubjectFeatures(test_raw_df, features_df, test_subject_df)<br/>
activity_column_test &nbsp;  <- CreateActivityColumn(activity_labels_df, test_subject_df)</b><br/>

<i>bind the activity column to get a properly labeled test dataset</i>
<b>test_with_subject_activity_features_df<- cbind(test_subject_features_df, activity_column_test)</b><br/>

<i>
&nbsp;Answer to 1. Merges the training and the test sets to create one data set.<br/>
&nbsp;&nbsp;&nbsp;&nbsp;The new dataset is called - merged_training_test_df<br/>
#<br/>
</i>

<b>merged_training_test_df <- rbind(training_with_subject_activity_features_df, test_with_subject_activity_features_df) </b><br />

<i>Answet to 2. Extracts only the measurements on the mean and standard deviation for each measurement.<br/>

<b>mean_standardDeviation_each_measurement_df <- select(merged_training_test_df, <br/>
&nbsp;&nbsp;&nbsp;&nbsp;Subject, <br/>
&nbsp;&nbsp;&nbsp;&nbsp; Activity, <br/>
&nbsp;&nbsp;&nbsp;&nbsp;`tBodyAcc-mean()-X`, <br/>
&nbsp;&nbsp;&nbsp;&nbsp;`tBodyAcc-mean()-Y`, <br/>
&nbsp;&nbsp;&nbsp;&nbsp;`tBodyAcc-mean()-Z`, <br/>
&nbsp;&nbsp;&nbsp;&nbsp;`tBodyAcc-std()-X`, <br/>
&nbsp;&nbsp;&nbsp;&nbsp;`tBodyAcc-std()-Y`, <br/>
&nbsp;&nbsp;&nbsp;&nbsp;`tBodyAcc-std()-Z`)</b><br/>

<i>Answer to 3. Uses descriptive activity names to name the activities in the data set<br/>
This has already been done above with the functions activity_column_training<- CreateActivityColumn(activity_labels_df, training_subject_df)<br/>
training_with_subject_activity_features_df<- cbind(training_subject_features_df, activity_column_training)<br/>
activity_column_test   <- CreateActivityColumn(activity_labels_df, test_subject_df)<br/>
test_with_subject_activity_features_df<- cbind(test_subject_features_df, activity_column_test)<br/>
mean_standardDeviation_each_measurement_df<br/></i>

<i>Answer to 4. Appropriately labels the data set with descriptive variable names.<br/>
I have used the following labels for the columns using the colnames function

Coulmn &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Renamed to <br/> 
&nbsp;tBodyAcc-mean()-X&nbsp;&nbsp;BodyAcc_mean_X<br/>
&nbsp;tBodyAcc-mean()-Y&nbsp;&nbsp;  BodyAcc_mean_Y<br/>
&nbsp;tBodyAcc_mean()-Z&nbsp;&nbsp;  BodyAcc_mean_Z<br/>
&nbsp;tBodyAcc-std()-X&nbsp;&nbsp;   BodyAcc_std_X<br/>
&nbsp;tBodyAcc-std()-Y&nbsp;&nbsp;   BodyAcc_std_Y<br/>
&nbsp;tBodyAcc-std()-Z&nbsp;&nbsp;   BodyAcc_std()_Z<br/>

</i>

<b>colnames(mean_standardDeviation_each_measurement_df) <- c("Subject", "Activity","BodyAcc_mean_X", "BodyAcc_mean_Y", "BodyAcc_mean_Z","BodyAcc_std_X","BodyAcc_std_Y","BodyAcc_std_Z")<br/> </b>

<i>Answer to 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. <br/>

I used the ddply summerize function calc the mean, and sd for each activity of the subjects c("Subject", "Activity")<br/>
I have ysed the summarise function to summarise the columns means and for standard deviation (sd)<br/> 
<b>tidy_dataset <-ddply(mean_standardDeviation_each_measurement_df,<br/> 
&nbsp;&nbsp;&nbsp;&nbsp; c("Subject", "Activity"), summarise,<br/>
&nbsp;&nbsp;&nbsp;&nbsp;  Mean_BodyAcc_X = mean(BodyAcc_mean_X),<br/>
&nbsp;&nbsp;&nbsp;&nbsp;  Mean_BodyAcc_Y = mean(BodyAcc_mean_Y),<br/>
&nbsp;&nbsp;&nbsp;&nbsp;  Mean_BodyAcc_Z = mean(BodyAcc_mean_Z),<br/>
&nbsp;&nbsp;&nbsp;&nbsp;  SD_BodyAcc_X = sd(BodyAcc_std_X),<br/>
&nbsp;&nbsp;&nbsp;&nbsp;  SD_BodyAcc_Y = sd(BodyAcc_std_Y),<br/>
&nbsp;&nbsp;&nbsp;&nbsp;  SD_BodyAcc_Z = sd(BodyAcc_std_Z)<br/>
&nbsp;&nbsp;&nbsp;&nbsp;  )<br/></b>

<i>Save dataset to file named : TidyDataSet.txt</i></br>
<b>write.table(tidy_dataset, file = "TidyDataSet.txt",row.names=FALSE)</b></br></br>
<i>End of assignment.</i></br>
<i>Thanks for reading :)</i></br>
