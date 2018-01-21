#File location is in:
#set working directory
setwd("C:/Users/Kero/Documents/RExercise/cleaning_data_project")

# Reading trainings tables:
x_train <- read.table("./project_data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./project_data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./project_data/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("./project_data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./project_data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./project_data/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features <- read.table('./project_data/UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels = read.table('./project_data/UCI HAR Dataset/activity_labels.txt')

#Assign column names
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

#Merge the dataset
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)


#get the measurement of mean and std
colNames <- colnames(setAllInOne)

#create vector for id,mean,std
mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)

#create new dataset with tidy data
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

#write dataset to file in working directory
write.table(secTidySet, "TidyDataSet.txt", row.name=FALSE)


