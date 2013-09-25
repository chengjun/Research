# Subset a corpus and DocumentTermMatrix in R
# Chengjun @ AMOY, HONG KONG
# 2012 Sep 25

library(tm)

data("crude")

'1. Inspect the meta data'
meta(crude)
meta(crude[[1]])
meta(crude, type = "corpus")
DublinCore(crude[[1]])

'2. Modify tags'
meta(crude[[1]], tag = "Topics")
meta(crude[[1]], tag = "Topics") <- NULL
meta(crude[[1]], tag = "Topics") # check the change
meta(crude[[1]], tag = "Topics") <- 'who you are'
meta(crude[[1]], tag = "Topics") # check the change


meta(crude[[1]], tag = "Comment") <- "A short comment." # modfiy the tag content
meta(crude[[1]], tag = "Comment") # check the modified tag content

DublinCore(crude[[1]], tag = "creator") <- "Ano Nymous"
DublinCore(crude[[1]], tag = "Format") <- "XML"
DublinCore(crude[[1]])

'3. Add new meta data on the corpus'
meta(crude, "add_labels") <- 21:40
meta(crude)

'4. Select corpus by meta data'
crude[meta(crude)$add_labels%in%22:30]

'5. Subset a DocumentTermMatrix'
dtm <- DocumentTermMatrix(crude,
                          control = list(weighting =
                                           function(x)
                                             weightTfIdf(x, normalize =
                                                           FALSE),
                                         stopwords = TRUE))
dtm.mat <- as.matrix(dtm)
# subset dtm by document ids
docids = rownames(dtm.mat)[1:5]
dtm.mat_sub = dtm.mat[rownames(dtm.mat) %in% docids, ]

'This is another way to subset dtm, and you can subset by the other document attributes'

'6. understanding filters'

getFilters()

attr(searchFullText, "doclevel")
tm_filter(crude, FUN = searchFullText, "company",
          doclevel = TRUE, useMeta = FALSE)
tm_index(crude, FUN = searchFullText, "company")

sfilterfun = sFilter(crude, "id == '127' & heading == 'DIAMOND SHAMROCK (DIA) CUTS CRUDE PRICES'")
sFilter(crude, "Places == 'usa'")
