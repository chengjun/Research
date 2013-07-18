# WANG, Chengjun
# For IMC project
# 20111115


id<-read.csv("D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/imc_manual_coding_results4.csv", header = T, sep = ",",  dec = ",")

full<-read.csv("D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/finding_clean_nouns_1.csv", header = T, sep = ",",  dec = ",")
# conceptual, literature, method, finding, discussion, fulltext
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
full$num<-1 # frequency of words can be caculated by generate a new value full$num<-1
full$lemma<-as.character(full$lemma)
full_agg<-aggregate(full$num, by=list(full$lemma, full$ArticleID), FUN=sum)
# subset(full, full$ArticleID==32&full$lemma=="aad") # this check for the case of aad in paper 32, it works
# first aggregate, and then merge 
# then i can aggregate id1$lemma with the list (), to see the sum.
names(full_agg)<-c("word", "ArticleID", "freq")

id1<-as.data.frame(cbind(id$ID, as.character(id$MC_topic), id$relevant ))
names(id1)<-c("ArticleID", "MC_topic", "relevant")
full_agg_mer<-merge(full_agg, id1, by="ArticleID")

# length(data.frame(table(full_agg_mer$ArticleID))[,1])==209, much less than 409, what's wrong???
# head(full_agg_mer)
# write.csv(full_agg_mer, "D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/full_agg_mer.csv")
# fool<-read.csv("D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/full_agg_mer.csv", # header = T, # sep = ",",  dec = ",")
# head(fool)
# table(fool$MC_topic)

fool<-full_agg_mer
# select ad and pr papers
ad<-subset(fool, fool$MC_topic=="ad")
pr<-subset(fool, fool$MC_topic=="pr")

# using reshape2::dcast to convert cases to variables
library(reshape2)
ad1<-data.frame(ad$ArticleID, ad$word, ad$freq)
pr1<-data.frame(pr$ArticleID, pr$word, pr$freq)
names(ad1)<-c("ArticleID", "word", "freq")
names(pr1)<-c("ArticleID", "word", "freq")
ad_data<-reshape2::dcast(ad1, ad1$ArticleID~ad1$word, sum)
pr_data<-reshape2::dcast(pr1, pr1$ArticleID~pr1$word, sum)

colnames(ad_data)[1] <- "ArticleID"
colnames(pr_data)[1] <- "ArticleID"
# merge ad_data with id$relevant

ad_data_merge<-merge(ad_data, id1, by="ArticleID")
pr_data_merge<-merge(pr_data, id1, by="ArticleID")

# write.csv(ad_data_merge, "D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five # sections/ad_data_merge.csv")
# write.csv(pr_data_merge, "D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five # sections/pr_data_merge.csv")
# sort columns by colSums for discriminal analysis
# ad_sum<-read.csv("D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five # sections/ad_data_merge.csv", header = T, sep = ",",  dec = ",")
# pr_sum<-read.csv("D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five # sections/pr_data_merge.csv", header = T, sep = ",",  dec = ",")
ad_sum<-ad_data_merge
pr_sum<-pr_data_merge

ad_sum$MC_topic<-1  # change ad to 1 as numeric for the following step.
pr_sum$MC_topic<-1  # change ad to 1 as numeric for the following step.


ad_sum$relevant<- as.numeric(levels(ad_sum$relevant)[ad_sum$relevant])
pr_sum$relevant<- as.numeric(levels(pr_sum$relevant)[pr_sum$relevant])  # change this factor to numeric

ad_sum["Total" ,] <- colSums(ad_sum)
sum1 <- colSums(ad_sum)
pr_sum["Total" ,] <- colSums(pr_sum)
sum2 <- colSums(pr_sum)


ad.new <- ad_sum[,c("ArticleID","MC_topic", "relevant", names(sort(sum1, decreasing=TRUE)))]
pr.new <- pr_sum[,c("ArticleID","MC_topic", "relevant", names(sort(sum2, decreasing=TRUE)))]

 write.csv(ad.new, file="D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/ad_finding_sort.csv")
 write.csv(pr.new, file="D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/pr_finding_sort.csv")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~end~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# now we have twelve doc for conceptual, literature, method, finding, discussion, fulltext.
pr_conceptual_sort<-read.csv("D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/pr_conceptual_sort.csv", header = T, sep = ",",  dec = ",")
ad_conceptual_sort<-read.csv("D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/ad_conceptual_sort.csv", header = T, sep = ",",  dec = ",")

#test<-rbind(pr_conceptual_sort, ad_conceptual_sort)# rbind doesn't work

pr_literature_sort<-read.csv("D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/pr_literature_sort.csv", header = T, sep = ",",  dec = ",")
ad_literature_sort<-read.csv("D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/ad_literature_sort.csv", header = T, sep = ",",  dec = ",")

pr_conceptual_sort$cat<-1
ad_conceptual_sort$cat<-2
pr_literature_sort$cat<-3
ad_literature_sort$cat<-4
pr_method_sort$cat<-5
ad_method_sort$cat<-6
pr_discussion_sort$cat<-7
ad_discussion_sort$cat<-8
pr_finding_sort$cat<-9
ad_finding_sort$cat<-10
pr_fulltext_sort$cat<-11
ad_fulltext_sort$cat<-12

pr_method_sort<-read.csv("D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/pr_method_sort.csv", header = T, sep = ",",  dec = ",")
ad_method_sort<-read.csv("D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/ad_method_sort.csv", header = T, sep = ",",  dec = ",")


pr_discussion_sort<-read.csv("D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/pr_discussion_sort.csv", header = T, sep = ",",  dec = ",")
ad_discussion_sort<-read.csv("D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/ad_discussion_sort.csv", header = T, sep = ",",  dec = ",")


pr_finding_sort<-read.csv("D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/pr_finding_sort.csv", header = T, sep = ",",  dec = ",")
ad_finding_sort<-read.csv("D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/ad_finding_sort.csv", header = T, sep = ",",  dec = ",")



pr_fulltext_sort<-read.csv("D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/pr_fulltext_sort.csv", header = T, sep = ",",  dec = ",")
ad_fulltext_sort<-read.csv("D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/ad_fulltext_sort.csv", header = T, sep = ",",  dec = ",")



# they have different columns or variables
names(pr_conceptual_sort)
 
library(reshape) 
result<-rbind.fill(pr_conceptual_sort,ad_conceptual_sort,pr_literature_sort,ad_literature_sort,pr_method_sort,
 ad_method_sort,pr_discussion_sort,ad_discussion_sort,pr_finding_sort,ad_finding_sort,pr_fulltext_sort,ad_fulltext_sort) 

write.csv(result, "D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/data.csv")

# dataset1<-aggregate(result, by=list(result$cat), na.action = na.omit, FUN=sum)
# result[NA] <- 0
result[ is.na(result) ] <- 0 # I stopped because this is a dirty work

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# discriminant analysis
ad_sort<-read.csv("D:/Micro-blog/Literature of micro-blog/Dropbox/IMC/data to compare for five sections/ad_data_sort.csv", header = T, sep = ",",  dec = ",")
ad<-ad_sort[1:155,1:20] # choose variables

# Linear Discriminant Analysis with Jacknifed Prediction 
library(MASS)
fit <- lda(ad[,4] ~ ad[,5] + ad[,6] + ad[,7], data=ad, na.action="na.omit", CV=TRUE)
fit # show results
# Assess the accuracy of the prediction
# percent correct for each category of G
ct <- table(ad$relevant, fit$class)
diag(prop.table(ct, 1))
# total percent correct
sum(diag(prop.table(ct)))

fitq <- qda(ad[,4] ~ ad[,5] + ad[,6] + ad[,7], data=na.omit(ad))
# Scatter plot using the 1st two discriminant dimensions 
plot(fit) # fit from lda  
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# each row is one paper.
names(full)   # ArticleID
names(id)     # ID
 
table(id$MC_topic) # ad mc pr
table(id$mc_topic2)
table(id$MC_Type) # Internet Match
table(id$mc_type2)=

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




