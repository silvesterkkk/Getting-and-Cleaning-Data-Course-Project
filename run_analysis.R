library(plyr)
library(data.table)

subject_train = read.table('UCI HAR Dataset/train/subject_train.txt',header=FALSE)
x_train = read.table('UCI HAR Dataset/train/x_train.txt',header=FALSE)
y_train = read.table('UCI HAR Dataset/train/y_train.txt',header=FALSE)

subject_test = read.table('UCI HAR Dataset/test/subject_test.txt',header=FALSE)
x_test = read.table('UCI HAR Dataset/test/x_test.txt',header=FALSE)
y_test = read.table('UCI HAR Dataset/test/y_test.txt',header=FALSE)

all_x <- rbind(x_train, x_test)
all_y <- rbind(y_train, y_test)
all_subject <- rbind(subject_train, subject_test)
dim(all_x)


all_x_mean_std <- all_x[, grep("-(mean|std)\\(\\)", read.table("UCI HAR Dataset/features.txt")[, 2])]
names(all_x_mean_std) <- read.table("UCI HAR Dataset/features.txt")[grep("-(mean|std)\\(\\)", 
                                                                         read.table("UCI HAR Dataset/features.txt")[, 2]), 2] 
View(all_x_mean_std)
dim(all_x_mean_std)

all_y[, 1] <- read.table("UCI HAR Dataset/activity_labels.txt")[all_y[, 1], 2]
names(all_y) <- "Activity"
View(all_y)

names(all_subject) <- "Subject"
summary(all_subject)

# Organizing and combining all data sets into single one.

indv_set <- cbind(all_x_mean_std, all_y, all_subject)

# Defining descriptive names for all variables.

names(indv_set) <- make.names(names(indv_set))
names(indv_set) <- gsub('Acc',"Acceleration",names(indv_set))
names(indv_set) <- gsub('GyroJerk',"AngularAcceleration",names(indv_set))
names(indv_set) <- gsub('Gyro',"AngularSpeed",names(indv_set))
names(indv_set) <- gsub('Mag',"Magnitude",names(indv_set))
names(indv_set) <- gsub('^t',"TimeDomain.",names(indv_set))
names(indv_set) <- gsub('^f',"FrequencyDomain.",names(indv_set))
names(indv_set) <- gsub('\\.mean',".Mean",names(indv_set))
names(indv_set) <- gsub('\\.std',".StandardDeviation",names(indv_set))
names(indv_set) <- gsub('Freq\\.',"Frequency.",names(indv_set))
names(indv_set) <- gsub('Freq$',"Frequency",names(indv_set))

View(indv_set)

Data2 <- aggregate(. ~Subject + Activity, indv_set, mean)
Data2 <- Data2[order(Data2$Subject,Data2$Activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
