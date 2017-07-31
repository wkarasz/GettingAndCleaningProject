# GettingAndCleaningProject
Coursera Data Science Class - Getting and Cleaning End Project
## CodeBook
Describes the variables, the data, and any transformations or work performed to clean up the data.
-The script run_analysis.R uses the extracted file from the following URL
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
-The training and test data are combined into 3 sets of files
--X_combined.txt
--y_combined.txt
--subject_combined.txt

-The resultant data set/variables contain only the subset of original data in which the column names indicated mean or standard deviation. e.g. mean()-X or std()-Y.  Some columns were omitted, because, although they indicated mean() or std(), they were not the direct measurements.
-The column names omitted the following symbols -, (, ) from the original file names (because there was a perceived error encountered).
-The data set contains a column, subject_number
-The data set contains a column, activity.  This data is derived from the activity_lables.txt file.





## Acknowledgements
Data set provided by:
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012