# Chengjun WANG @ CMC of City Univeristy of Hong Kong # using Lab PC of 88
# data cleaning syntax for the raw data of Ocuppying WallStreet Tweets.
# http://twitterminer.r-shief.org/owscsv/ 
# 20111210

ows<-read.csv("d:/chengjun/Twitter data/Ocuupy Wallstreet Data/OccupyWallstreetRawData.csv", header = T, sep = ",", dec = ".")
# dim(ows)  [1] 1353413      14  # names(ows)
# ows=ows[,-3]  #drop the nth column  # ows=ows[,-13]  #drop the nth column
# write.csv(ows, "d:/chengjun/Twitter data/Ocuupy Wallstreet Data/OccupyWallstreetData.csv")

#~~~~~~~~~~~~~~subset the interaction~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
inter<-subset(ows, ows[,11]!="	" )
# dim(inter)  # 88601    12
# write.csv(inter, "d:/chengjun/Twitter data/Ocuupy Wallstreet Data/OccupyWallstreetInterData.csv")
# class(ows[,11]) # it's factor
# ows$To.User[1:100] # compare to # inter$To.User[1:100]

#~~~~~~~~~~~~~~~~~~~~content~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
inter$Text[1:200]  # including RT and @ in the sentence. 
inter$To.User[1:200]

#~~~~~~~~~~~~~~~~~~~~~~~~temporal trend~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
plot(data.frame(table(inter$Day)))
plot(data.frame(table(ows$Day)))
(data.frame(table(ows$Day)))$Freq
# compare to the google trends
# http://www.google.com.hk/trends?q=occupy+wall+street&ctab=0&geo=all&date=2011&sort=0

plot(data.frame(table(ows$Geo)))

