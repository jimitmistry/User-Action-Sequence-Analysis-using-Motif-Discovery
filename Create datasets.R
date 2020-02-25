rm(list=ls()) # Clear all user objects from the environment!!!
setwd("/Users/mistr/OneDrive/Documents/IST687/Homework")
library(sqldf)
library(data.table)
library(reshape2)
library(dplyr)
library(tidyverse)

combined_activities_51319 <- read_csv("./combined_activities_51319.csv")
glitches <- read_csv("./glitches-limited.csv")

combined_activities_51319$links_workflow[(combined_activities_51319$links_workflow == '1610')] <- 1
combined_activities_51319$links_workflow[(combined_activities_51319$links_workflow == '1934')] <- 2
combined_activities_51319$links_workflow[(combined_activities_51319$links_workflow == '1935')] <- 3
combined_activities_51319$links_workflow[(combined_activities_51319$links_workflow == '2360')] <- 4
combined_activities_51319$links_workflow[(combined_activities_51319$links_workflow == '2117')] <- 5

colnames(combined_activities_51319)[colnames(combined_activities_51319)=="new.category2"] <- "category2"

combined_activities_51319$subjectID[combined_activities_51319$subjectID == 'N'] <- NA

df_new <- sqldf("
                SELECT *
                FROM combined_activities_51319 d1
                INNER JOIN glitches d2
                ON d1.subjectID == d2.links_subjects")
write.csv (df_new, 'all_data.csv')

View(head(df_new))

df_super <- sqldf("
             SELECT *
             FROM combined_activities_51319 d1 
             WHERE d1.links_workflow == 5
             ")
write.csv (df_super, 'superusers.csv')

df4_super <- sqldf("
             SELECT *
             FROM combined_activities_51319 d2
             WHERE d2.links_workflow == 4 AND d2.userID IN (SELECT userID FROM df_super)
             ")
write.csv (df4_super, 'superusers_lvl4.csv')

df4_other <- sqldf("
             SELECT *
             FROM combined_activities_51319 d1
             WHERE d1.links_workflow == 4 and d1.userID NOT IN (SELECT userID FROM df_super)
             ")
write.csv (df4_other, 'other_lvl4.csv')


df3_super <- sqldf("
             SELECT *
             FROM combined_activities_51319 d2
             WHERE d2.links_workflow == 3 AND d2.userID IN (SELECT userID FROM df_super)
             ")
write.csv (df3_super, 'superusers_lvl3.csv')

df3_other <- sqldf("
             SELECT *
             FROM combined_activities_51319 d1
             WHERE d1.links_workflow == 3 and d1.userID NOT IN (SELECT userID FROM df_super)
             ")
write.csv (df3_other, 'other_lvl3.csv')

df2_super <- sqldf("
             SELECT *
             FROM combined_activities_51319 d2
             WHERE d2.links_workflow == 2 AND d2.userID IN (SELECT userID FROM df_super)
             ")
write.csv (df2_super, 'superusers_lvl2.csv')

df2_other <- sqldf("
             SELECT *
             FROM combined_activities_51319 d1
             WHERE d1.links_workflow == 2 and d1.userID NOT IN (SELECT userID FROM df_super)
             ")
write.csv (df2_other, 'other_lvl2.csv')


df1_super <- sqldf("
             SELECT *
             FROM combined_activities_51319 d2
             WHERE d2.links_workflow == 1 AND d2.userID IN (SELECT userID FROM df_super)
             ")
write.csv (df1_super, 'superusers_lvl1.csv')

df1_other <- sqldf("
             SELECT *
             FROM combined_activities_51319 d1
             WHERE d1.links_workflow == 1 and d1.userID NOT IN (SELECT userID FROM df_super)
             ")
write.csv (df1_other, 'other_lvl1.csv')

