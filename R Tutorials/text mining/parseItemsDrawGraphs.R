#####################################################################
'arules: Mining association rules'                   
#####################################################################
library(arules)
library(arulesViz)

dtmm<- as(as.matrix(dt[,2:6]), "transactions")

rules <- apriori(dtmm, parameter = list(supp = 0.5, conf = 0.9, minlen=1, target = "rules")) 
itemsets<- apriori(dtmm,parameter = list(supp = 0.5, minlen=1,target = "frequent itemsets"))

# plot itemsets
it = as(itemsets, "data.frame")
subset2<-itemsets[size(itemsets)>1]
subset2<-sort(subset2) # [1:100]
subset3<-itemsets[size(itemsets)>2]
par(mfrow=c(1,2))
plot(subset2, method="graph",control=list(main="至少包含两个词语的前100个项集"))
plot(subset3, method="graph",control=list(main="至少包含三个词语的所有项集"))

# plot items
png(paste("d:/chengjun/honglou/arulesViz_3",  ".png", sep = ''), 
    width=10, height=10, 
    units="in", res=700,
    family="MOESung-Regular",type="cairo")

plot(rules, method="graph", control=list(type="items")) # "items" or "itemsets"

dev.off()

# list(lhs(rules) , decode=T) [[1]]
# list(rhs(rules) , decode=T) [[1]]

parseAssociationItems = function(x, y){
  x1 = labels(x(y))$elements # items
  x1 = gsub("{", "", x1, , fixed="TRUE")
  x1 = gsub("}", "", x1, , fixed="TRUE")
  x1 = strsplit(x1, ",")
  for (i in 1:length(x1)) x1[[i]] = ifelse(length(x1[[i]]) >= 2, 0, x1[[i]])  
  return (x1)
}

lhss = unlist(parseAssociationItems(lhs, rules))
rhss = unlist(parseAssociationItems(rhs, rules))
uniItems = labels(rhs(rules))$items

ru = as(rules, "data.frame")

edgelist = data.frame(lhss, rhss, ru)
edgelist = subset(edgelist, edgelist$lhss%in%uniItems & edgelist$rhss%in%uniItems)

g <- graph.data.frame(edgelist, directed=TRUE)
plot(g)
