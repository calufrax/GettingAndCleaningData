# GettingAndCleaningData
For use in Gatting And Cleaning Data MOOC from Johns Hopkins

Current code is a bit kludgy, due to issues getting columns extracted and inserted properly...

-Load up plyr and dplyr libraries, though these are not currently used
-Load up the features and activity labels lists, used for categories
-Load up data sets 
-Combine test and training sets, then label. This gives a big data sheet, 10299x564
-Then look for the terms "mean" or "Mean", and "std" (standard deviation), and extract those
   columns into a smaller dataset (10299x89)
-Extract by activity and test subject, take means, then reassemble.
-write final, clean data file.
