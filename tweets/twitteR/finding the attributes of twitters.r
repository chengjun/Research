# Script for graphing Twitter friends/followers
# by Kai Heinrich (kai.heinrich@mailbox.tu-dresden.de) 
 
# load the required packages
 
library("twitteR")
library("igraph")
 
# HINT: In order for the tkplot() function to work on mac you need to install 
#       the TCL/TK build for X11 
#       (get it here: http://cran.us.r-project.org/bin/macosx/tools/)
#
# Get User Information with twitteR function getUSer(), 
#  instead of using ur name you can do this with any other username as well 

#~~~~~~~~~~~~~~~~~~~~~~~~~Authentication with OAuth~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# ONLY R2.13 CAN INSTALL RJSONIO
library(ROAuth)
cred <- OAuthFactory$new(consumerKey ='1tEqlc1UzY7rzwtgrqbuCQ',
     consumerSecret = 'mxHyBeb6qHIv8YvARlV4B0wPVJclnpCjUNWFA2XxBxw',
     requestURL= 'http://api.twitter.com/oauth/request_token',
     accessURL= 'http://api.twitter.com/oauth/access_token',
     authURL= 'http://api.twitter.com/oauth/authorize')
cred$handshake()
#

top200to<-read.csv("D:/github/tweets/twitteR/top200to.csv", header = T, sep = ",",  dec = ".")
top200fr<-read.csv("D:/github/tweets/twitteR/top200from.csv", header = T, sep = ",",  dec = ".")

top200toname<-as.character(top200to$Var1)
top200frname<-as.character(top200fr$Var1)

# name:screenName:id:lastStatus:description:statusesCount:followersCount:favoritesCount:friendsCount:
# url:created:protected:verified:location:
tuser <- getUser('geoffjentry') # one time one people
tuser<- lookupUsers(c('geoffjentry', 'whitehouse'))      ## This requires OAuth authentication

f<-function(n){
  tuser <- getUser(n) # one time one people
   description<-tuser$description
   # followersCount<-tuser$followersCount
   # friendsCount<-tuser$friendsCount
   # statusesCount<-tuser$statusesCount
   # favoritesCount<-tuser$favoritesCount
   m=data.frame(cbind(followersCount, friendsCount,statusesCount))
   return(m)  
   }
 dto1<-sapply(top200toname[1:10],f)  
 dto2<-sapply(top200toname[11:20],f)  #
 dto3<-sapply(top200toname[21:30],f)  #
 dto4<-sapply(top200toname[31:40],f)  
 dto5<-sapply(top200toname[41:50],f)  #
 dto6<-sapply(top200toname[51:60],f)  
 dto7<-sapply(top200toname[61:70],f)  
 dto8<-sapply(top200toname[71:80],f)  
 dto9<-sapply(top200toname[81:90],f)  
 dto10<-sapply(top200toname[91:100],f)  
 dto11<-sapply(top200toname[101:110],f)  
 dto12<-sapply(top200toname[111:120],f)  #
 dto13<-sapply(top200toname[121:130],f)  
 dto14<-sapply(top200toname[131:140],f)  
 dto15<-sapply(top200toname[141:150],f)  
 dto16<-sapply(top200toname[151:160],f)  #
 dto17<-sapply(top200toname[161:170],f)  #
 dto18<-sapply(top200toname[171:180],f)  #
 dto19<-sapply(top200toname[181:190],f)  #
 dto20<-sapply(top200toname[191:200],f)  #
write.csv(dto1, "D:/github/tweets/twitteR/dto1.csv")
/write.csv(to2, "D:/github/tweets/twitteR/to2.csv")
write.csv(to3, "D:/github/tweets/twitteR/to3.csv")
write.csv(to4, "D:/github/tweets/twitteR/to4.csv")
write.csv(to5, "D:/github/tweets/twitteR/to5.csv")
write.csv(to6, "D:/github/tweets/twitteR/to6.csv")
write.csv(to7, "D:/github/tweets/twitteR/to7.csv")
write.csv(to8, "D:/github/tweets/twitteR/to8.csv")
write.csv(to9, "D:/github/tweets/twitteR/to9.csv")
write.csv(to10, "D:/github/tweets/twitteR/to10.csv")
write.csv(to11, "D:/github/tweets/twitteR/to11.csv")
write.csv(to12, "D:/github/tweets/twitteR/to12.csv")
write.csv(to13, "D:/github/tweets/twitteR/to13.csv")
write.csv(to14, "D:/github/tweets/twitteR/to14.csv")
write.csv(to15, "D:/github/tweets/twitteR/to15.csv")
write.csv(to16, "D:/github/tweets/twitteR/to16.csv")
write.csv(to17, "D:/github/tweets/twitteR/to17.csv")
write.csv(to18, "D:/github/tweets/twitteR/to18.csv")
write.csv(to19, "D:/github/tweets/twitteR/to19.csv")
write.csv(to20, "D:/github/tweets/twitteR/to20.csv")


# Error: Rate limit exceeded. Clients may not make more than 150 requests per hour.
# Thus, it's not possible to get the ruslt in this way.

 tuser <- getUser('EricAllenBell')
 # id<-tuser$id
 # lastStatus<-tuser$lastStatus # the latest tweets
 description<-tuser$description
 statusesCount<-tuser$statusesCount
 followersCount<-tuser$followersCount
 favoritesCount<-tuser$favoritesCount
 friendsCount<-tuser$friendsCount
 verified<-tuser$verified

 users <- lookupUsers(c('geoffjentry', 'whitehouse'))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~friendship networks~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
start<-getUser("EricAllenBell") 
 
# Get Friends and Follower names with first fetching IDs (getFollowerIDs(),getFriendIDs()) 
# and then looking up the names (lookupUsers()) 

friends.object<-lookupUsers(start$getFriendIDs())
follower.object<-lookupUsers(start$getFollowerIDs())
 
# Retrieve the names of your friends and followers from the friend
# and follower objects. You can limit the number of friends and followers by adjusting the 
# size of the selected data with [1:n], where n is the number of followers/friends 
# that you want to visualize. If you do not put in the expression the maximum number of 
# friends and/or followers will be visualized.
 
n<-20 
friends <- sapply(friends.object[1:n],name)
followers <- sapply(followers.object[1:n],name)
 
# Create a data frame that relates friends and followers to you for expression in the graph
relations <- merge(data.frame(User='YOUR_NAME', Follower=friends), 
data.frame(User=followers, Follower='YOUR_NAME'), all=T)
 
# Create graph from relations.
g <- graph.data.frame(relations, directed = T)
 
# Assign labels to the graph (=people's names)
V(g)$label <- V(g)$name
 
# Plot the graph using plot() or tkplot(). Remember the HINT at the 
# beginning if you are using MAC OS/X
tkplot(g)
