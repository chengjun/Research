
library(arules)

data("AdultUCI"); names(AdultUCI); dim(AdultUCI)

AdultUCI[["fnlwgt"]] <- NULL
AdultUCI[["education-num"]] <- NULL
AdultUCI[[ "age"]] <- ordered(cut(AdultUCI[[ "age"]], c(15,25,45,65,100)),
                                labels = c("Young", "Middle-aged", "Senior", "Old"))
AdultUCI[[ "hours-per-week"]] <- ordered(cut(AdultUCI[[ "hours-per-week"]],
                                             c(0,25,40,60,168)),
                                         labels = c("Part-time", "Full-time", "Over-time", "Workaholic"))
AdultUCI[[ "capital-gain"]] <- ordered(cut(AdultUCI[[ "capital-gain"]],
                                           c(-Inf,0,median(AdultUCI[[ "capital-gain"]][AdultUCI[[ "capital-gain"]]>0]),Inf)),
                                       labels = c("None", "Low", "High"))
AdultUCI[[ "capital-loss"]] <- ordered(cut(AdultUCI[[ "capital-loss"]],
                                           c(-Inf,0,
                                             median(AdultUCI[[ "capital-loss"]][AdultUCI[[ "capital-loss"]]>0]),Inf)),
                                       labels = c("none", "low", "high"))
Adult <- as(AdultUCI, "transactions")
## data("Adult") # Actually, it has been stored in arules library

nf <- layout(matrix(c(1,1,1,1), 2, 2, byrow = TRUE), respect = TRUE)
layout.show(nf)
itemFrequencyPlot(Adult, support = 0.1, cex.names=0.8)

## Mine association rules.
rules <- apriori(Adult, 
                 parameter = list(supp = 0.5, conf = 0.9,
                                  target = "rules"))
summary(rules)
inspect(rules)