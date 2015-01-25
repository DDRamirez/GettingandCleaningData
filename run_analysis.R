## This code merges the training and test datasets.  It assumes that the files
## are downloaded in the current directory as they were in the zip file.
## So the data is in the "UCI HAR Dataset" folder.

##Test Set
library(dplyr)

##The files we'll be using.
## The Features file has the column names in it, so we read it in first.
FeatureFile <- ".\\UCI HAR Dataset\\features.txt"
SubjectTestFile <- ".\\UCI HAR Dataset\\test\\subject_test.txt"
XTestFile <- ".\\UCI HAR Dataset\\test\\X_test.txt"
YTestFile <- ".\\UCI HAR Dataset\\test\\Y_test.txt"
SubjectTrainFile <- ".\\UCI HAR Dataset\\train\\subject_train.txt"
XTrainFile <- ".\\UCI HAR Dataset\\train\\X_train.txt"
YTrainFile <- ".\\UCI HAR Dataset\\train\\Y_train.txt"
ActivityLabelFile <- ".\\UCI HAR Dataset\\activity_labels.txt"

Features <- read.table(FeatureFile, sep=" ")

##Ideally, we only want the mean() and std() columns.  Here we can create
## 2 logical columns for Mean and STD.

#Matching words
toMatch <- c("mean","std")

##Which columns match
DataColsKeep <- grep(paste(toMatch,collapse="|"),Features[,2],ignore.case=TRUE)

##The DataColClass will make the columns we want numeric and not read the others.
DataColClass <- rep(c("NULL"),561)
DataColClass[DataColsKeep] <- "numeric"

## The other read tables will take a column of column names, so we
##convert the names into a character vector.
DataCols <- as.character(Features[,2])
DataCols <- make.names(DataCols,unique=TRUE)

##Read in the XTest with column names.  Put Subjects first and test type last.
Subject_Test <- read.table(SubjectTestFile,col.names="Subject")
X_Test <- read.table(XTestFile,col.names=DataCols,colClasses=DataColClass)
Y_Test <- read.table(YTestFile,col.names="Activity")
TestData <- cbind(Subject_Test,X_Test,Y_Test)


##The Train data has the same column headings.
Subject_Train <- read.table(SubjectTrainFile,col.names="Subject")
X_Train <- read.table(XTrainFile,col.names=DataCols,colClasses=DataColClass)
Y_Train <- read.table(YTrainFile,col.names=c("Activity"))
TrainData <- cbind(Subject_Train,X_Train,Y_Train)

##The Train and Test data have the same columns, so I can rbind them into one.
## Not really hurting for memory, so I'll keep the original data frames.
All_Data <- rbind(TrainData,TestData)

##The Activities have labels.  Let's move those in.
ActLabels <- read.table(ActivityLabelFile,colClasses=c("integer","character"))

##We want to merge these with the "Activities" column of the All_Data df.
## Get rid of the numbers and keep the category.
merge(All_Data,ActLabels,by.x="Activity",by.y="V1")
Final <- merge(All_Data,ActLabels,by.x="Activity",by.y="V1")
Final$Activity <- NULL
names(Final)[names(Final)=="V2"] <- "Activity"

## Get the means for each subject and activity for all Columns.
FinalMeans <- aggregate(Final,by=list(Final$Subject,Final$Activity),FUN=mean)
FinalMeans$Subject <- NULL
FinalMeans$Activity <- NULL
names(FinalMeans)[names(FinalMeans)=="Group.1"] <- "Subject"
names(FinalMeans)[names(FinalMeans)=="Group.2"] <- "Activity"
write.table(FinalMeans,file="Means.txt",row.names=FALSE)
