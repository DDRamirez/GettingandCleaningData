README Before getting started
=============================

The run_analysis.r file in the repo is designed to run one level above the "UCI HAR Dataset" folder.
The script generates file names on that assumption and reads in the feature, data, and label files 
from the dataset, beginning with the features.  For the features, which are eventually used as
column headings, the file removes excess punctuation and attempts to make the headings more
descriptive.

Once the headings are ready the file then reads in the test and train data in separate blocks.  Each
set (train and test) have subjects and activities associated with them. The script attaches the subject
and activities to the test/train data.  Once the 2 blocks are created the code rbinds them into one
dataset.

There is also a list of descriptors for the activities that are merged into the dataset.  Once those 
are added the column means are calculated for each subject and activity.  Those are save as the FinalMeans
data frame and output as a text file called "Means.txt".