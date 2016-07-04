# CourseraGettingCleaningDataCourseProject
 Course Project for Getting and Cleaning Data from Coursera

Run_Analysis.R is the culmination of the course Getting and Cleaning Data from Coursera.
It seeks to obtain and transform Samsung Galaxy II phones data from UCI into tidy data.

The first part of the code, entitled "working directory" sets the working directory.
The second part, entitled "download file", downloads and unzips the file from the given URL.
The third part, entitled "load packages", loads dplyr, data.table, and tidyr.
The fourth, entitled "read files", reads the various .TXT files into R using read.table() and tbl_df().
The fifth, entitled "merge..." merges the testing and training data sets using rbind.
It also names variables using setnames() and colnames().
The section entitled "extract and measure..." uses grep(), union(), and subset() to take the mean and standard deviation.
The section entitled "label data set" uses names() to put in descriptive variable names.
Lastly, the final section creates a tidy data text file with write.table().
