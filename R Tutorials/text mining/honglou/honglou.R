
library(ggplot2)
# library(rmmseg4j)
library(Rwordseg)
library(tm)
library(MASS)
library(proxy)

library(topicmodels)
library(tm)
library(slam)
library(igraph)

library(lsa)

###########################################
'Data cleaning'
####################################

'#去除空白行'
text <- readLines("D:/chengjun/honglou/honglou.txt",encoding='UTF-8', n = -1)
person <- readLines("D:/chengjun/honglou/person.txt",encoding='UTF-8', n = -1)
pname = unique(unlist(strsplit(person, " ")))

text <- text[text!='']

'# 找出每一章节的头部行数和尾部行数'
chapbegin <- grep('第.{1,3}回 ',text)
chapend <- c((chapbegin-1)[-1],length(text))


'将整个文本分成120个段落，每个段落为一个章节'
chaptext <- character(120)
for ( i in 1:120) {
  temp <- text[chapbegin[i]:chapend[i]]
  chaptext[i] <- paste(temp,collapse='')
}

'Download dictionary of honglou http://pinyin.sogou.com/dict/cell.php?id=15131'
# installDict("D:/chengjun/honglou/honglou.scel", dictname = "honglou.scel",
#             dicttype = c("scel"))
insertWords(c("宝玉", "那")); segmentCN("那宝玉捉弄紫鹃", recognition = FALSE)
insertWords(pname); segmentCN("醉金刚打死潘三保")

segmentCN("那宝玉那才那黛玉那凤姐那贾那可")
# stopwords=readLines("your_home_path/CH_stopwords.txt")

chapwords <- lapply(1:120, function(i) segmentCN(chaptext[i], nature = TRUE, recognition = FALSE))
words <- lapply(1:120, function(i) chapwords[[i]][names(chapwords[[i]])%in% c("userDefine", "v", "nr", "n", "honglou.scel")])
# words <- lapply(1:120, function(i) chapwords[[i]][names(chapwords[[i]])%in% c("userDefine", "nr")])

wordcorpus <- Corpus(VectorSource(words), encoding = "UTF-8") # 组成语料库格式

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
png(paste("d:/chengjun/honglou/Perplexity_",try_num, "_gibbs5_100",".png", sep = ''), 
    width=5, height=5, 
    units="in", res=700)
matplot(k, df, type = c("b"), xlab = "Number of topics", 
        ylab = "Perplexity", pch=1:try_num,col = 1, main = '')       
legend("topright", legend = paste("fold", 1:try_num), col=1, pch=1:try_num) 

dev.off()


png(paste("d:/chengjun/honglou/LogLikelihood_",try_num, "_gibbs5_100",".png", sep = ''), 
    width=5, height=5, 
    units="in", res=700)
matplot(k, logLik, type = c("b"), xlab = "Number of topics", 
        ylab = "Log-Likelihood", pch=1:try_num,col = 1, main = '')       
legend("topright", legend = paste("fold", 1:try_num), col=1, pch=1:try_num) 
dev.off()

  k = 30
  SEED <- 2003
  jss_TM <- list(
    			VEM = LDA(dtm, k = k, control = list(seed = SEED)),
    			VEM_fixed = LDA(dtm, k = k, control = list(estimate.alpha = FALSE, seed = SEED)),
    			Gibbs = LDA(dtm, k = k, method = "Gibbs", 
                      control = list(seed = SEED, burnin = 1000, thin = 100, iter = 1000)),
          CTM = CTM(dtm, k = k, 
                   control = list(seed = SEED, var = list(tol = 10^-4), em = list(tol = 10^-3)))    )
  
  # Topic <- topics(jss_TM[["CTM"]], 5)
  # 		termsForPlot <- terms(jss_TM[["CTM"]], 10)
  # 		termsForSave<- terms(jss_TM[["CTM"]], 10)
  
  termsForSave1<- terms(jss_TM[["VEM"]], 10)
  termsForSave2<- terms(jss_TM[["VEM_fixed"]], 10)
  termsForSave3<- terms(jss_TM[["Gibbs"]], 10)
  termsForSave4<- terms(jss_TM[["CTM"]], 10)

  write.csv(as.data.frame(t(termsForSave1)), 
            paste("d:/chengjun/honglou/topic-document_p", "_VEM_", k, ".csv"),
            fileEncoding = "UTF-8")
  
  write.csv(as.data.frame(t(termsForSave2)), 
            paste("d:/chengjun/honglou/topic-document_p", "_VEM_fixed_", k, ".csv"),
            fileEncoding = "UTF-8")
  
  write.csv(as.data.frame(t(termsForSave3)), 
            paste("d:/chengjun/honglou/topic-document_p", "_Gibbs_", k, ".csv"),
            fileEncoding = "UTF-8")
  write.csv(as.data.frame(t(termsForSave4)), 
            paste("d:/chengjun/honglou/topic-document_p", "_CTM_", k, ".csv"),
            fileEncoding = "UTF-8")


'Refer to http://cos.name/2013/08/something_about_weibo/'

###########################################
'Latent semantic analysis'
###########################################
'http://www.inf.ed.ac.uk/teaching/courses/dme/2012/labs/lab2.html'

library(lsa)

'create some files'
# for (i in 1:120){
#   write(words[[i]], paste("D:/chengjun/honglou/td/", i, ".txt") )
# }
# myMatrix = textmatrix("D:/chengjun/honglou/td/", minWordLength=1) # textvector dla jednego pliku


dist.mat <- dist(t(as.matrix(dtm)))
fit <- cmdscale(dist.mat, eig = TRUE, k = 2)
points <- data.frame(x = fit$points[, 1], y = fit$points[, 2])


myMatrix = lw_bintf(as.matrix(dtm)) * gw_idf(as.matrix(dtm))
myLSAspace = lsa(myMatrix, dims=dimcalc_raw()) ; dim(myLSAspace$dk) # create the latent semantic space

round(as.textmatrix(myLSAspace),2) # should give the original

mls = lsa(myMatrix, dims=dimcalc_share()); dim(mls$dk)# create the latent semantic space
mnm = as.textmatrix(mls) # display it as a textmatrix again

# mls = lsa(myMatrix, dims=dimcalc_kaiser()); dim(mls$dk)# create the latent semantic space
# mnm = as.textmatrix(mls) # display it as a textmatrix again

dimv <- lapply(1:dim(mls$dk)[2], function(i) sort(mls$dk[,i],decreasing=T)[1:10])
dimname <- unlist(lapply(1:50, function(i) names(dimv[[i]])))

heatmap(as.matrix(dml),labRow = F, labCol = F)
fit <- hclust(d, method="ward")
# round(mls$tk %*% diag(mls$sk) %*% t(mls$dk))

# cosine(myNewMatrix["dog",], myNewMatrix["cat",])
# associate(myNewMatrix, "mouse")
# query("monster", rownames(myNewMatrix))
# query("monster dog", rownames(myNewMatrix)) 

cor(myNewMatrix[,1], myNewMatrix[,2], method="pearson") # compare two documents with pearson
t.locs<-myLSAspace$tk %*% diag(myLSAspace$sk)
plot(t.locs,type="n")
text(t.locs, labels=rownames(myLSAspace$tk))

# clean up
unlink(td, recursive=TRUE)

# # load training texts 
# trm = textmatrix("trainingtexts/") 
# trm = lw_bintf(trm) * gw_idf(trm) # 
# weighting 
# space = lsa(trm) # create LSA space 
# # fold-in test and gold standard essays 
# tem = textmatrix("essays/", 
#                  vocabulary=rownames(trm)) 
# tem = lw_bintf(tem) * gw_idf(tem) # 
# weighting 
# tem_red = fold_in(tem, space) 
# # score essay against gold standard 
# cor(tem_red[,"gold.txt"], 
#     tem_red[,"E1.txt"]) # 0.7 

#####################################
'Semantic network analysis'
#####################################
myMatrix = lw_bintf(as.matrix(dtm)) * gw_idf(as.matrix(dtm))
mls = lsa(myMatrix, dims=dimcalc_share()); dim(mls$dk)# create the latent semantic space
dimv <- lapply(1:dim(mls$dk)[2], function(i) sort(mls$dk[,i],decreasing=T)[1:10])
dimname <- unlist(lapply(1:dim(mls$dk)[2], function(i) names(dimv[[i]])))
dimname = unique(dimname); length(dimname)
dml <- dist(t(as.textmatrix(mls)),method='euclidean')  # compute distance matrix:tk, sk, dk
dmlm = as.matrix(dml)
dmlm = dmlm[rownames(dmlm)%in%dimname, colnames(dmlm)%in%dimname]; dim(dmlm)

g = graph.adjacency(dmlm, mode=c("undirected"), weighted=TRUE, diag=FALSE)    ; g         
V(g)$name = colnames(dmlm)

# term_tfidf <-tapply(dtm$v/row_sums(dtm)[dtm$i], dtm$j, mean) * log2(nDocs(dtm)/col_sums(dtm > 0))
# l1=term_tfidf >= quantile(term_tfidf, 0.5)       # second quantile, ie. median
# dtm <- dtm[,l1]
# 
# myMatrix = lw_bintf(as.matrix(dtm)) * gw_idf(as.matrix(dtm))
# mls = lsa(myMatrix, dims=dimcalc_share()); dim(mls$dk)# create the latent semantic space
# dml <- dist(t(as.textmatrix(mls)),method='euclidean')  # compute distance matrix:tk, sk, dk
# dmlm = as.matrix(dml)
# 
# g = graph.adjacency(dmlm, mode=c("undirected"), weighted=TRUE, diag=FALSE)             
# V(g)$name = colnames(dmlm)


edgelist = data.frame( get.edgelist(g, names = T) , round( E(g)$weight, 3 ), stringsAsFactors = FALSE)

edgelists = subset(edgelist, edgelist[,3] > quantile(edgelist[,3], 0.95) ); dim(edgelists); dim(edgelist)
# edgelistss = subset(edgelists, edgelists[,3] > quantile(edgelists[,3], 0.95) ); dim(edgelistss); dim(edgelists)

g <-graph.data.frame(edgelists,directed=FALSE )
E(g)$weight = edgelists[,3]

l<-layout.fruchterman.reingold(g)

# 明确节点属性
nodesize = centralization.degree(g)$res 
V(g)$size = log( centralization.degree(g)$res )
E(g)$width <- (log(E(g)$weight)-min(log(E(g)$weight)))/10

nodeLabel = V(g)$name

nodeLabel[which(!(V(g)$name%in% c("袭人","林黛玉",  "二爷",
                                  "凤姐儿", "贾琏", "贾政", "鸳鸯", "晴雯", # group 3
                                  "宝钗", "凤姐", "林妹妹", "薛蟠", "香菱", "宝二爷", "宝玉", "黛玉", "贾母"))) ] = ""; nodeLabel

 nodeLabel[which(nodesize <  quantile(nodesize, 0.5) )] = ""; nodeLabel
# 保存图片格式
png("d:/chengjun/honglou/latentsemanticnetwork_all_1.png", 
    width=10, height=10, 
    units="in", res=700)

plot(g, vertex.label= nodeLabel,  edge.curved=TRUE, vertex.frame.color=#FFFFFF,
     vertex.label.cex =0.6,  edge.arrow.size=0.02, layout=l )

# 结束保存图片
dev.off()

'Community detection for semantic network'
#####

fc <- fastgreedy.community(g); sizes(fc)
mfc = membership(fc)
for (i in 1:max(mfc)) cat("\n", i, names(mfc[mfc==i]), "\n")


V(g)$color[which(V(g)$name%in%names(mfc[mfc==1]))]="purple"
V(g)$color[which(V(g)$name%in%names(mfc[mfc==2]))]="blue"
V(g)$color[which(V(g)$name%in%names(mfc[mfc==3]))]="green"
V(g)$color[which(V(g)$name%in%names(mfc[mfc==4]))]="red"
V(g)$color[which(V(g)$name%in%names(mfc[mfc==5]))]="grey"
V(g)$color[which(V(g)$name%in%names(mfc[mfc==6]))]="yellow"

png("d:/chengjun/honglou/latentsemanticnetwork_community_dection2.png", 
    width=10, height=10, 
    units="in", res=700)

plot(g, vertex.label= nodeLabel,  edge.curved=TRUE, 
     vertex.label.cex =1,  edge.arrow.size=0.02, layout=l )

# 结束保存图片
dev.off()

###########################################
'word cloud'
######################################################

library(wordcloud)
m <- as.matrix(dtm)
# calculate the frequency of words
v <- sort(colSums(m), decreasing=TRUE)
myNames <- names(v)
d <- data.frame(word=myNames, freq=v)
par(mar = rep(2, 4))

png(paste("d:/chengjun/honglou/wordcloud50_",  ".png", sep = ''), 
    width=10, height=10, 
    units="in", res=700)

pal2 <- brewer.pal(8,"Dark2")
wordcloud(d$word,d$freq, scale=c(5,0.2), min.freq=mean(d$freq),
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


###########################################
'The other analysis'
###########################################


# "#计算出每一回的段落数，似乎在后四十回段落数较小"
# 
# paragraph <- chapend-chapbegin
# plotdata1 <- data.frame(freq=paragraph,cha=1:120)       
# p1 <- ggplot(data=plotdata1,aes(x=cha,y=freq))
# p1 + geom_bar(stat="identity",fill='black',colour='white')+
#   geom_vline(x=80,colour='red4',size=1,linetype=2)
# 
# "检验两部分的段落数是否有显著差异"
# wilcox.test(paragraph[1:80],paragraph[81:120])
# library(coin) #置换检验
# testdata <- data.frame(freq=paragraph,cha=factor(rep(1:2,times=c(80,40))))
# oneway_test(freq~cha,data=testdata,distribution='exact')
# # 计算每个章节的字数
parachar <- nchar(chaptext)

# 建立一个搜索函数，可以返回出现的频次
findfun <- function(name) {
  gregout <- gregexpr(name,chaptext) 
  namefun <- function(x) { #x表示章节序号
    temp <- attr(gregout[[x]],'match.length')
    ifelse(temp[1]>0,length(temp),0)
  }
  sapply(1:120,FUN=namefun)
}

# 搜索三位主角的出现次数
x1 <- findfun('宝玉')
x2 <- findfun('黛玉')
x3 <- findfun('宝钗')
x <- c(x1,x2,x3)
people <- factor(rep(1:3,each=120),
                 labels=c('宝玉','黛玉','宝钗'))
plotdata4 <- data.frame(freq=x,people=people,cha=1:120)

p4 <- ggplot(data=plotdata4,aes(x=cha,y=freq,fill=people,colour=people))
p4 + geom_bar(stat="identity",position='fill')

# 搜索标点的出现次数，标点的次数意味着句子数量的多少。
x1 <- findfun('？')
x2 <- findfun('。')
x3 <- findfun('！')
biaodian <- x1+x2+x3

#建立一个数据框，其中有段落数、句子数和字数
# 绘制每章节中句子的数量
plotdata2 <- data.frame(paragraph,biaodian,parachar,cha=1:120)       
p2 <- ggplot(data=plotdata2,aes(x=cha,y=biaodian))
p2 + geom_bar(stat="identity",fill='black',colour='white')+
  geom_vline(x=80,colour='red4',size=1,linetype=2)

# 绘制每章节中每段句子的数量
p3 <- ggplot(data=plotdata2,aes(x=cha,y=biaodian/paragraph))
p3 + geom_point()+stat_smooth(method='loess',se=F,span = 0.2)+
  geom_vline(x=80,colour='red4',size=1,linetype=2)


# 计算文档间的距离
chapdist <- dissimilarity(dtm, method = "cosine")
# 降到二维画图
mds=isoMDS(chapdist,k=2)
x = mds$points[,1]
y = mds$points[,2]
cha=factor(rep(1:2,times=c(80,40)),labels=c('前八十回','后四十回'))
plotdata3 <- data.frame(x,y,cha)
p=ggplot(plotdata3,aes(x,y))
p+geom_point(aes(colour=cha))


