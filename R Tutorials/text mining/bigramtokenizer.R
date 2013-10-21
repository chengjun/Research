library("RWeka")
library("tm")

data("crude")

BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 4))
tdm <- TermDocumentMatrix(crude, control = list(tokenize = BigramTokenizer))

inspect(tdm[340:345,1:10])