# WANG, Chengjun
# For IMC project
# 20111115



id<-read.csv("D:/Dropbox/IMC/data to compare for five sections/imc_manual_coding_results2.csv", header = T, sep = ",",  dec = ",")
full<-read.csv("D:/Dropbox/IMC/data to compare for five sections/conceptual_clean_nouns_1.csv", header = T, sep = ",",  dec = ",")

id1<-as.data.frame(cbind(id$ID, as.character(id$MC_Type), id$relevant))
names(id1)<-c("ArticleID", "MC_Type", "relevant")

full_1<-merge(full, id1, by="ArticleID")

full_2<-aggregate(full_1, by=list(full_1$ArticleID), FUN="mean", simplify = TRUE)# sth is wrong with r's aggregate function.


# each row is one paper.
names(full)   # ArticleID
names(id)     # ID
 
table(id$MC_topic) # ad mc pr
table(id$mc_topic2)
table(id$MC_Type) # Internet Match
table(id$mc_type2)

id_pr<-subset(id, id$MC_topic=="pr")
id_ad<-subset(id, id$MC_topic=="ad")
id_mc<-subset(id, id$MC_topic=="mc")
pr<-subset(full, full$ArticleID%in%id_pr$ID)
ad<-subset(full, full$ArticleID%in%id_ad$ID)
mc<-subset(full, full$ArticleID%in%id_mc$ID)
dim(pr)+dim(ad)  # 368 is much less than 407, something is wrong. Change the data to 2. 402 is much better

id_pr_int<-subset(id, id$MC_topic=="pr"&id$MC_Type=="Internet")
id_pr_non<-subset(id, id$MC_topic=="pr"&id$MC_Type=="Match")
id_ad_int<-subset(id, id$MC_topic=="ad"&id$MC_Type=="Internet")
id_ad_non<-subset(id, id$MC_topic=="ad"&id$MC_Type=="Match")
pr_int<-subset(full, full$ArticleID%in%id_pr_int$ID)
pr_non<-subset(full, full$ArticleID%in%id_pr_non$ID)
ad_int<-subset(full, full$ArticleID%in%id_ad_int$ID)
ad_non<-subset(full, full$ArticleID%in%id_ad_non$ID)

length(table(pr_int[,1])) 
length(table(pr_non[,1])) 
length(table(ad_int[,1])) 
length(table(ad_non[,1])) 

# we need to put all the words togehter to see 

pr_int_tab<-data.frame(table(pr_int[,2]))

pr_non_tab<-data.frame(table(pr_non[,2]))

ad_int_tab<-data.frame(table(ad_int[,2]))

ad_non_tab<-as.data.frame(table(ad_non[,2]))

write.csv(pr_int_tab, "D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/pr_int_tab.csv")
write.csv(pr_non_tab, "D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/pr_non_tab.csv")
write.csv(ad_int_tab, "D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/ad_int_tab.csv")
write.csv(ad_non_tab, "D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/ad_non_tab.csv")




