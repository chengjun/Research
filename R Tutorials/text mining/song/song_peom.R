# Text mining of Song peoms
# http://cos.name/tag/%E5%AE%8B%E8%AF%8D/ 
# Cheng-Jun Wang @amoy


library(Rwordseg)
require(rJava)
library(tm)
library(slam)
library(topicmodels)
setwd("D:/github/Research/R Tutorials/text mining/song")
txt=read.csv("SongPoem.csv",colClasses="character")

sentences=strsplit(txt$Sentence,"，|。|！|？|、")
######
'Word seg'
######

poem_words <- lapply(1:length(txt$Sentence), function(i) segmentCN(txt$Sentence[i], nature = TRUE))
# words <- lapply(1:120, function(i) chapwords[[i]][names(chapwords[[i]])%in% c("n", "nr", "v", "honglou.scel")])

wordcorpus <- Corpus(VectorSource(poem_words), encoding = "UTF-8") # 组成语料库格式

Sys.setlocale(locale="Chinese")
dtm <- DocumentTermMatrix(wordcorpus,
                          control = list(
                            wordLengths=c(1, Inf), # to allow long words
                            bounds = list(global = c(5,Inf)), # each term appears in at least 5 docs
                            removeNumbers = TRUE, 
                            # removePunctuation  = list(preserve_intra_word_dashes = FALSE),
                            weighting = weightTf, 
                            encoding = "UTF-8")
)

colnames(dtm)

dtm2 <- DocumentTermMatrix(wordcorpus,
                           control = list(
                             wordLengths=c(2, Inf), # to allow long words
                             bounds = list(global = c(5,Inf)), # each term appears in at least 5 docs
                             removeNumbers = TRUE, 
                             # removePunctuation  = list(preserve_intra_word_dashes = FALSE),
                             weighting = weightTf, 
                             encoding = "UTF-8")
)

colnames(dtm2)

findFreqTerms(dtm, 1000)
findFreqTerms(dtm2, 500)

###########################################
'Topic modeling'
###########################################

term_tfidf <-tapply(dtm$v/row_sums(dtm)[dtm$i], dtm$j, mean) * log2(nDocs(dtm)/col_sums(dtm > 0))
l1=term_tfidf >= quantile(term_tfidf, 0.5)       # second quantile, ie. median
dtm <- dtm[,l1]

dtm = dtm[row_sums(dtm)>0, ]; dim(dtm) # 2246 6210
summary(col_sums(dtm))
##
fold_num = 10
kv_num =  c(5, 10*c(1:5, 10))
seed_num = 2003
try_num = 1

smp<-function(cross=fold_num,n,seed)
{
  set.seed(seed)
  dd=list()
  aa0=sample(rep(1:cross,ceiling(n/cross))[1:n],n)
  for (i in 1:cross) dd[[i]]=(1:n)[aa0==i]
  return(dd)
}

selectK<-function(dtm,kv=kv_num,SEED=seed_num,cross=fold_num,sp) # change 60 to 15
{
  per_ctm=NULL
  log_ctm=NULL
  for (k in kv)
  {
    per=NULL
    loglik=NULL
    for (i in 1:try_num)  #only run for 3 replications# 
    {
      cat("R is running for", "topic", k, "fold", i,
          as.character(as.POSIXlt(Sys.time(), "Asia/Shanghai")),"\n")
      te=sp[[i]]
      tr=setdiff(1:dtm$nrow, te) # setdiff(nrow(dtm),te)  ## fix here when restart r session
      
      # VEM = LDA(dtm[tr, ], k = k, control = list(seed = SEED)),
      # VEM_fixed = LDA(dtm[tr,], k = k, control = list(estimate.alpha = FALSE, seed = SEED)),
      
      #       CTM = CTM(dtm[tr,], k = k, 
      #                 control = list(seed = SEED, var = list(tol = 10^-4), em = list(tol = 10^-3)))  
      #       
      Gibbs = LDA(dtm[tr,], k = k, method = "Gibbs",
                  control = list(seed = SEED, burnin = 1000,thin = 100, iter = 1000))
      
      per=c(per,perplexity(Gibbs,newdata=dtm[te,]))
      loglik=c(loglik,logLik(Gibbs,newdata=dtm[te,]))
    }
    per_ctm=rbind(per_ctm,per)
    log_ctm=rbind(log_ctm,loglik)
  }
  return(list(perplex=per_ctm,loglik=log_ctm))
}

sp=smp(n=dtm$nrow, seed=seed_num) # n = nrow(dtm)

system.time((ctmK=selectK(dtm=dtm,kv=kv_num,SEED=seed_num,cross=fold_num,sp=sp)))

## plot the perplexity

m_per=apply(ctmK[[1]],1,mean)
m_log=apply(ctmK[[2]],1,mean)

k=c(kv_num)
df = ctmK[[1]]  # perplexity matrix
logLik = ctmK[[2]]  # perplexity matrix

# save the figure
png(paste("d:/chengjun/honglou/Perplexity_",try_num, "_gibbs20_400",".png", sep = ''), 
    width=5, height=5, 
    units="in", res=700)
matplot(k, df, type = c("b"), xlab = "Number of topics", 
        ylab = "Perplexity", pch=1:try_num,col = 1, main = '')       
legend("topright", legend = paste("fold", 1:try_num), col=1, pch=1:try_num) 

dev.off()


png(paste("d:/chengjun/honglou/LogLikelihood_",try_num, "_gibbs20_400",".png", sep = ''), 
    width=5, height=5, 
    units="in", res=700)
matplot(k, logLik, type = c("b"), xlab = "Number of topics", 
        ylab = "Log-Likelihood", pch=1:try_num,col = 1, main = '')       
legend("topright", legend = paste("fold", 1:try_num), col=1, pch=1:try_num) 
dev.off()

k = 40
SEED <- 2003
jss_TM <- list(
  VEM = LDA(dtm, k = k, control = list(seed = SEED)),
  VEM_fixed = LDA(dtm, k = k, control = list(estimate.alpha = FALSE, seed = SEED)),
  Gibbs = LDA(dtm, k = k, method = "Gibbs", 
              control = list(seed = SEED, burnin = 1000, thin = 100, iter = 1000)),
  CTM = CTM(dtm, k = k, 
            control = list(seed = SEED, var = list(tol = 10^-4), em = list(tol = 10^-3)))    )

# Topic <- topics(jss_TM[["CTM"]], 5)
#   	termsForPlot <- terms(jss_TM[["CTM"]], 10)
# 		termsForSave<- terms(jss_TM[["CTM"]], 10)

termsForSave1<- terms(jss_TM[["VEM"]], 10)
termsForSave2<- terms(jss_TM[["VEM_fixed"]], 10)
termsForSave3<- terms(jss_TM[["Gibbs"]], 10)
termsForSave4<- terms(jss_TM[["CTM"]], 10)

write.csv(as.data.frame(t(termsForSave1)), 
          paste("d:/chengjun/honglou/topic-document_", "_VEM_", k, ".csv"),
          fileEncoding = "UTF-8")

write.csv(as.data.frame(t(termsForSave2)), 
          paste("d:/chengjun/honglou/topic-document_", "_VEM_fixed_", k, ".csv"),
          fileEncoding = "UTF-8")

write.csv(as.data.frame(t(termsForSave3)), 
          paste("d:/chengjun/honglou/topic-document_", "_Gibbs_", k, ".csv"),
          fileEncoding = "UTF-8")
write.csv(as.data.frame(t(termsForSave4)), 
          paste("d:/chengjun/honglou/topic-document_", "_CTM_", k, ".csv"),
          fileEncoding = "UTF-8")


'Refer to http://cos.name/2013/08/something_about_weibo/'


###########################################
'word cloud'
######################################################

library(wordcloud)
library(slam)

# term_tfidf <-tapply(dtm$v/row_sums(dtm)[dtm$i], dtm$j, mean) * log2(nDocs(dtm)/col_sums(dtm > 0))
# l1=term_tfidf >= quantile(term_tfidf, 0.5)       # second quantile, ie. median
# dtm01 <- dtm[,l1]
# dtm01 = dtm01[row_sums(dtm01)>5, ]; dim(dtm01) # 2246 6210 
# summary(col_sums(dtm01))

m <- as.matrix(dtm2)
# calculate the frequency of words
v <- sort(colSums(m), decreasing=TRUE)
myNames <- names(v)
d <- data.frame(word=myNames, freq=v)
par(mar = rep(2, 4))

png(paste(getwd(), "/wordcloud50_",  ".png", sep = ''), 
    width=10, height=10, 
    units="in", res=700)

pal2 <- brewer.pal(8,"Dark2")
wordcloud(d$word,d$freq, scale=c(5,.2), min.freq=mean(d$freq),
          max.words=100, random.order=FALSE, rot.per=.15, colors=pal2)
dev.off()



# dtm <- inspect(dtm_vb)
# DF <- as.data.frame(dtm, stringsAsFactors = FALSE)
# write.table(DF, "D:/Chengjun/Crystal/Result/ashoka/strategy/dtmvb.csv")

###########################################
'Term Clustering'
#######################################################
dtm1 <- weightTfIdf(dtm)
dtm1 <- removeSparseTerms(dtm1, 0.0583333335);dtm1

tdm = as.TermDocumentMatrix(dtm1)
tdm <- weightTfIdf(tdm)
# convert the sparse term-document matrix to a standard data frame
mydata.df <- as.data.frame(inspect(tdm))
mydata.df.scale <- scale(mydata.df)
d <- dist(mydata.df.scale, method = "euclidean") # distance matrix
fit <- hclust(d, method="ward")

png(paste("d:/chengjun/honglou/honglou_termcluster_50_", ".png", sep = ''), 
    width=10, height=10, 
    units="in", res=700)
plot(fit) # display dendogram?

dev.off()



groups <- cutree(fit, k=2) # cut tree into 5 clusters
# draw dendogram with red borders around the 5 clusters
rect.hclust(fit, k=2, border="red")


######
'Frequency analysis'
######
sentences=unlist(sentences)
sentences=sentences[sentences!=""]
s.len=nchar(sentences)
sentences=sentences[s.len<=15]
s.len=nchar(sentences)
##
splitwords=function(x,x.len) substring(x,1:(x.len-1),2:x.len)
#  substring("abcdef", 1:(6-1), 2:6)
words=mapply(splitwords,sentences,s.len,SIMPLIFY=TRUE,USE.NAMES=FALSE)
words=unlist(words)
words.freq=table(words)
words.freq=sort(words.freq,decreasing=TRUE)
words.freq[1:100]

######
'author analysis'
######

author = doc$Author
cipai = doc$Title2
tab = table(author, cipai)

r1 = sort(table(author), decreasing = TRUE)[1:20]
r1 = data.frame(Author = names(r1), Freq = r1)
rownames(r1) = 1:nrow(r1)
r1

r2 = sort(table(cipai), decreasing = TRUE)[1:20]
r2 = data.frame(Cipai = names(r2), Freq = r2)
rownames(r2) = 1:nrow(r2)
r2

par(mfrow = c(1, 2))
M = cor(mtcars)
order.AOE = corrMatOrder(M, order = "AOE")
M.AOE = M[order.AOE, order.AOE]
corrplot(M)
corrplot(M.AOE)
corrRect(c(4, 2, 5))

visualizeMatrix = function(m)
{
  m = m > 0
  par(mar = c(0, 0, 0, 0))
  m = m[nrow(m):1, ]
  image(1:ncol(m), 1:nrow(m), t(m), col = c("black", "white"),
        useRaster = TRUE)
}
# 0-1矩阵
visualizeMatrix(tab[, ])
# 矩阵排序
library(seriation)
set.seed(123)
ord = seriate(tab[, ] > 0)
m = permute(tab[, ], ord)
visualizeMatrix(m)
# 极坐标计算
coord = which(m > 0, arr.ind = TRUE)
theta = (coord[, 2] - 1) / (max(coord[,2 ]) - 1) * 359 / 180 * pi
rho = coord[, 1] / max(coord[, 1])
x = rho * cos(theta)
y = rho * sin(theta)
# 极坐标图
par(bg = "black", mar = c(0, 0, 0, 0))
plot(x, y, col = "white", pch = ".")
# 平滑散点图
par(bg = "black", mar = c(0, 0, 0, 0))
mypalette = colorRampPalette(c("#1F1C17", "#637080",
                               "#CBC2B7", "#D2D6D9"),
                             space = "Lab")
smoothScatter(x, y, colramp = mypalette, nbin = 600, bandwidth = 0.1,
              col = "white", nrpoints = Inf)



