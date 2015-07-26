#if they haven't been loaded, the plyr and dplyr libraries
library(plyr)
library(dplyr)

##open up the overall folder
activityLabels <- read.table("activity_labels.txt")       #labels for the activity
featuresList <- read.table("features.txt")                #features list
##open the train folder
setwd("train")
#load training data
subject_train<-read.table("subject_train.txt")            #who is the subject
x_train<-read.table("X_train.txt")                        #the training set
y_train<-read.table("y_train.txt")                        #which activity
#leave train folder
setwd("..")

##open the test folder
setwd("test")
#load test data
subject_test<-read.table("subject_test.txt")              #who is the subject
x_test<-read.table("X_test.txt")                          #the training set
y_test<-read.table("y_test.txt")                          #which activity
#leave test folder
setwd("..")


#joing training and test sets
singleSubject <- rbind(subject_train,subject_test)
singleX <- rbind(x_train,x_test)
singleY <- rbind(y_train,y_test)
#change activity to text
activityText <- activityLabels[singleY[,1],2]

#join subject, activities; and label
singleData <- cbind(singleSubject,singleY,activityText)
colnames(singleData)<-c("Subject","Activity#","Activity")
#label that large dataset with column labels
colnames(singleX)<-featuresList[,2]

bigDataSheet <- cbind(singleData,singleX)
#gives us a datasheet of 10299 x 564

#out of the combined data list, find and extract only those which display the mean or standard deviation
whichToExtract <- unique(c(grep("mean",featuresList[,2]), grep("Mean",featuresList[,2]),grep("std",featuresList[,2])))
featuresToExtract <- singleX[whichToExtract[order(whichToExtract)]]
smallDataSheet <- cbind(singleData,featuresToExtract)
#which leaves us with a datasheet that is 10299 x 89
#now need to make tidy data set, rows for person and activity, columns are means.

rangeActivities <- range(smallDataSheet[,2])
rangeSubjects <- range(smallDataSheet[,1])
#create a sheet for clean data that we know is empty.
cleanData <- NULL

#want to find a better way than nested for loops, but this will test the concept
#it's not in any way elegant
for (subjectLoop in rangeSubjects[1]:rangeSubjects[2]) {
  for (activityLoop in 1:rangeActivities[2]) {
    dummySet <- smallDataSheet[(smallDataSheet[,1]==subjectLoop & smallDataSheet[,2]==activityLoop),]
    dummyLabel<- activityLabels[activityLoop,2]
    dummyNumber <- dim(dummySet)[2] - 4 + 1
    meanOfDummy <- colMeans(dummySet[4:(dim(dummySet)[2])],na.rm=TRUE)
    dummyRow <- cbind("Subject"=subjectLoop,"Activity#"=activityLoop,t(meanOfDummy))
    cleanData <- rbind(cleanData,dummyRow)
  }
}
summaryLabels <- cbind("Activity"=as.character(activityLabels[cleanData[,2],2]))
finalData<-as.data.frame(cleanData)
finalData<-as.data.frame(cbind(finalData[,1:2],summaryLabels,finalData[3:(dim(finalData)[2])]))

