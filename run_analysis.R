# set working directory
library(reshape2)
setwd("/Users/aetyang/Documents/R-coursera/data")


# load activity labels and features

activity_labels <- read.table("activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])
features <- read.table("features.txt")
features[,2] <- as.character(features[,2])


# extract mean and SD

features_mean_sd <- grep(".*mean.*|.*std*",features[,2])
features_mean_sd.names <- features[features_mean_sd,2]
features_mean_sd.names = gsub('-mean','Mean',features_mean_sd.names)
features_mean_sd.names = gsub('-std','Std',features_mean_sd.names)
features_mean_sd.names <- gsub('[-()]','',features_mean_sd.names)


#load files that we will be working with

training_dataset <- read.table("X_train.txt")[features_mean_sd]
training_dataset_labels <-  read.table("y_train.txt")
training_subjects <- read.table("subject_train.txt")
training_dataset <- cbind(training_subjects,training_dataset_labels,training_dataset)


test_dataset <- read.table("X_test.txt")[features_mean_sd]
test_dataset_labels <-  read.table("y_test.txt")
test_subjects <- read.table("subject_test.txt")
test_dataset <- cbind(test_subjects,test_dataset_labels,test_dataset)


# merge the datasets and include labels
combined_dataset <-  rbind(test_dataset,training_dataset)
colnames(combined_dataset) <- c("subject","activity",features_mean_sd.names)

# transform activities and subjects into factors
combined_dataset$activity <- factor(combined_dataset$activity,levels = activity_labels[,1],labels = activity_labels[,2])
combined_dataset$subject <- as.factor(combined_dataset$subject)

combined_dataset.melted <- melt(combined_dataset,id = c("subject","activity"))
combined_dataset.mean <- dcast(combined_dataset.melted,subject + activity ~ variable, mean)

write.table(combined_dataset.mean,"tidy_dataset.txt",row.names = FALSE, quote = FALSE)





