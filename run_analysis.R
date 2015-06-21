library(plyr)

# Define all the relevant paths.
remote_url          <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
dest_url            <- file.path(".", "UCI HAR Dataset", "exdata%2Fdata%2FNEI_data.zip")
unzipped_url        <- file.path(".", "UCI HAR Dataset")

train_url           <- file.path(unzipped_url, "train", "X_train.txt")
train_subject_url   <- file.path(unzipped_url, "train", "subject_train.txt")
train_activity_url  <- file.path(unzipped_url, "train", "y_train.txt")

test_url            <- file.path(unzipped_url, "test", "X_test.txt")
test_subject_url    <- file.path(unzipped_url, "test", "subject_test.txt")
test_activity_url   <- file.path(unzipped_url, "test", "y_test.txt")

features_url        <- file.path(unzipped_url, "features.txt")
activity_labels_url <- file.path(unzipped_url, "activity_labels.txt")
output_url          <- file.path(".", "results.txt")

# Download the data, unzip.
download.file(remote_url, destfile=dest_url, method="curl")
unzip(dest_url, exdir=unzipped_url)

# Obtain a list of the columns we are interested in.
features <- read.table(features_url, header=FALSE, stringsAsFactors=FALSE)
names(features)   <- c("index", "feature")
interesting_features <- grep("(.*mean.*)|(.*std.*)",tolower(features$feature))

# Obtain a translation table for the activities.
activity_labels <- read.table(activity_labels_url, header=FALSE, stringsAsFactors=FALSE)
names(activity_labels) <- c("activity", "label")

# First we perform all operations for the train set, then for the test set. 
# For simplicity now the code is duplicated, but it is now easy to in the next step refactor the code 
# and make a general function that can be applied over any set. Deepest Apologies for the duplication.

# Handle the training data.
# First read the training data.
data_train <- read.table(train_url, header=FALSE, stringsAsFactors=FALSE)
# Set the column names.
names(data_train) <-gsub("[()]", "", features$feature)
# Select the columns names that we are interested in: belonging to a mean or std.
data_train <- subset(data_train, select=interesting_features)
# Read the activities.
data_activity_train <- read.table(train_activity_url, header=FALSE, stringsAsFactors=FALSE)
names(data_activity_train) <- c("activity")
# Read the testsubjects
data_subject_train <- read.table(train_subject_url, header=FALSE, stringsAsFactors=FALSE)
names(data_subject_train) <- c("subject")
# Set the correct label per activity
data_activity_train <- merge(data_activity_train, activity_labels, by.x="activity", by.y = "activity", all=FALSE)
# Merge in the activities and the subjects in the train set
data_train$subject  <- data_subject_train$subject
data_train$activity <- data_activity_train$label


# Handle the test data.
# First read the test data.
data_test <- read.table(test_url, header=FALSE, stringsAsFactors=FALSE)
# Set the column names.
names(data_test)  <- gsub("[()]", "", features$feature)
# Select the columns names that we are interested in: belonging to a mean or std.
data_test <- subset(data_test, select=interesting_features)
# Read the activities.
data_activity_test  <- read.table(test_activity_url, header=FALSE, stringsAsFactors=FALSE)
names(data_activity_test) <- c("activity")
# Read the testsubjects
data_subject_test <- read.table(test_subject_url, header=FALSE, stringsAsFactors=FALSE)
names(data_subject_test) <- c("subject")
# Set the correct label per activity
data_activity_test <- merge(data_activity_test, activity_labels, by.x="activity", by.y = "activity", all=FALSE)
# Merge in the activities and the subjects in the test set
data_test$subject   <- data_subject_test$subject
data_test$activity  <- data_activity_test$label


# Merge the train and test datasets.
data <- merge(data_train, data_test, all=TRUE)

# Calculate the means for all columns per subject per activity.
summary_data <- ddply(data, .(subject, activity), colwise(mean))

# Write the final results.
write.table(summary_data, file = output_url, row.name=FALSE)
