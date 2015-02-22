# Codebook for getdata_project

### Preamble
Data is from experiments carried out with a group of 30 volunteers. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone. 3-axial linear acceleration and 3-axial angular velocity measurements were captured. The obtained dataset was partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

### Original files used:
	activity_labels.txt	-	activity codes (1 through 6) and their descriptions
	features.txt		-	names of the measures recorded as columns in the X-train and X_test files
	subject_train		-	id of the person associated with each observation in the training group
	subject_test		-	id of the person associated with each observation in the test group
	y_train			-	activity code associated with each observation in the training group
	y_test			-	activity code associated with each observation in the test group
	X_train			-	measure readings associated with each observation in the training group
	X_test			-	measure readings associated with each observation in the test group

### Transformations:
1. The subject_train, y_train and X_train data is combined together via a couple of merges by observation number (row number). The same is done for the test data, and then the two dataframes are bound together to create one large dataframe containing the subject, activity code and measure values for all observations.

2. The columns containing mean and standard deviation data are identified by finding all feature names that contain either 'mean()' or 'std()'. A new data frame is created that contains the subject, activity code and only the mean and std related measure columns.

3. The measure columns are renamed with the actual feature names.

4. A column for activity description is added by merging with the activity_labels by activity code, and the activity code column dropped.

5. The tidy data set is then created by grouping by activity and subject and then summarising to get the mean of each measure value within those groups.

### Output Dataset:
The tidy_data set consists of 180 rows, ie. 6 activities by 30 subjects (persons). The columns contain the average of the measure values for the mean() and std() type measures as defined above.
