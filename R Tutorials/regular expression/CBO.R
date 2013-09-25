############################################################################
# code for Complexity-Based Ordering Analysis with R
# R. H. Baayen, Edmonton 2007-2008
#
# higher-level functions:
#    loadData.fnc()             load data from example csv file
#    plotmat.fnc()              plot adjacency matrix
#    analysis.fnc()             find adjacency matrix with minimal violations
#    sampleAdjacencySpace.fnc   time-consuming search with 10,000 random 
#                               adjacency matrices as starting point
#
# further code for plotting digraphs etc requires the steps given here,
# these commands need to be executed only once
############################################################################

installCommandsDontRun.fnc = function() {

  stop("don't run this, it requires hand tweaking!\n")

  install.packages("graph")
  install.packages("RBGL")
  source("http://bioconductor.org/biocLite.R")
  biocLite()
  # install graphviz libraries with ubuntu package manager outside R, this
  # is necessary for installing Rgraphviz in R:
  biocLite("Rgraphviz")

}

############################################################################
# the following example shows how to plot the adjacency matrix
############################################################################

examplesOfAnalysisAndPlotting.fnc = function(){

  stop("don't run, do this by hand and study results\n")

  library(graph)
  library(RBGL)
  library(Rgraphviz)


  mOrig = loadData.fnc()
  plotmat.fnc(mOrig)
  res = analysis.fnc(mOrig)
  m = as.matrix(res$m)
  mG = as(m, "graphNEL")
  print(mG)
  isConnected(mG)
  plot(mG)
  plotAndHighlightViolations.fnc(m, mG)
}


############################################################################
# this function is specialized for the English data, and hand-codes the
# exceptional edges, but then produces a nice plot with violations highlighted
# THE HIGHLIGHTING IS CORRECT ONLY WHEN APPLIED TO THE GRAPHNEL OBJECT 
# OBTAINED STRAIGHT FROM loadData.fnc()
############################################################################

plotAndHighlightViolations.fnc = function(mmm=m, mmmG=mG, withplot=FALSE) {

  v = rep("transparent", ncol(mmm))
  names(v) = colnames(mmm)
  myedgelist = edges(mmmG)
  mynodelist = nodes(mmmG)
  wnames = "start"
  for (beg in 1:length(myedgelist)) {
    if (length(myedgelist[[beg]]) > 0) {
      for (end in 1:length(myedgelist[[beg]])) {
        wnames = c(wnames, paste(mynodelist[beg], "~", myedgelist[[beg]][end], sep="")) 
      }
    }
  }
  wnames=wnames[-1]
  w = rep("grey", length(wnames))
  names(w) = wnames



  w["ship~ment"] = "black"
  w["ish~ment"] = "black"
  w["aryA~ment"] = "black"  # 2-cycle
  w["ment~aryA"] = "black"
  w["ist~aryN"] = "black"   # 2-cycle
  w["aryN~ist"] = "black"
  w["ish~ian"] = "black"    # 2-cycle
  w["ian~ish"] = "black"
  w["ish~ist"] = "black"
  w["ist~ish"] = "black"    # 2-cycle
  w["ist~er"] = "black"     # 2-cycle
  w["er~ist"] = "black"
  # w["lyAJ~ish"] = "black"
  w["ery~ist"] = "black"    # 2-cycle
  w["ist~ery"] = "black"
  w["ness~less"] = "black"    # 2-cycle
  w["less~ness"] = "black"
  w["ness~wise"] = "black"    # 2-cycle
  w["wise~ness"] = "black"

  a=rep("2.0", ncol(mmm))
  names(a) = colnames(mmm)
  b=rep("30.0", ncol(mmm))
  names(b) = colnames(mmm)

  if (withplot == TRUE) pdf("figures/mmmG.pdf", he=7,wi=9)
  plot(mmmG, nodeAttrs=list("color"=v, "width"=a, "fontsize"=b), 
    edgeAttrs=list("color"=w))
  if (withplot == TRUE) dev.off()
}

#############################################################################
# function for finding counts of violations, illustrates the innards of
# graphnel objects, returns data frame.
#############################################################################

findViolationsInGraphViz.fnc = function(mG) {
  x = plot(mG)
  nodes = AgNode(x)
  res = data.frame(affix=rep(" ", length(nodes)), 
  x=rep(0, length(nodes)), y=rep(0, length(nodes)))
  res$affix = as.character(res$affix)
  for (i in 1:length(nodes)) {
    naam = name(nodes[[i]])
    xcoord = getNodeXY(nodes[[i]])$x
    ycoord = getNodeXY(nodes[[i]])$y
    res[i,]$affix = naam
    res[i,]$x = xcoord
    res[i,]$y = ycoord
  }
  res = res[rev(order(res$y)),]
  res$som = rep(0, nrow(res))
  for (i in 1:nrow(res)) {
    aff = res$affix[i]
    v = acc(mmmG, aff)[[1]]
    v = v[v==1]
    res$som[i] = sum(res[as.character(res$affix) %in% names(v),]$y >= res[res$affix==aff,]$y)
  }

  return(res)
}

############################################################################
# this function loads spreadsheat data in yes/- format, transforms it into
# an adjacency matrix that it returns
############################################################################

loadData.fnc = function(filename="CBO.csv"){
  tmp = read.csv(filename, header = TRUE)
  namen = c("ery", "ian", "age", "aryA", "aryN", "dom", "ee",
  "en", "er", "ess", "ette", "fold", "fulA", "fulN", "hood",
  "ish", "ism", "ist", "ive", "less", "ling", "lyAJ", "lyAV",
  "ment", "ness", "or", "ous", "ship", "ster", "th", "wise") 

  tmp = tmp[,2:ncol(tmp)] 
  rownames(tmp) = namen
  colnames(tmp) = namen
  tmp["ness","less"] = "yes"

  n = nrow(tmp)
  m = matrix(0, n, n)
  rownames(m) = namen
  colnames(m) = namen
  for (i in 1:n) {
    for (j in 1:n) {
      if (tmp[i,j] == "yes") m[i,j] = 1
    }
  }

  cat("raw error count is ", sum(m[lower.tri(m)]!=0), "\n")

  return(m)
}

############################################################################
# this function plots an adjacency matrix in tabular form
############################################################################

plotmat.fnc = function(m, withdots=FALSE) {
  n = nrow(m)
  xvec = 0:n
  plot(xvec,xvec,type="n",xlab=" ", ylab = " ", xaxt="n", yaxt="n")
  for (i in 1:n) {
	  v1 = rep(i,n)
	  v2 = n:1
	  xv=as.vector(m[,i])
    if (withdots) {
      xv = as.character(xv)
      xv[xv=="-1"] = "." 
      text(v1, v2, xv, col=ifelse(xv==".","lightgrey","black"), cex=0.8)
    } else {
      text(v1, v2, xv, col=ifelse(xv==0,"lightgrey","black"), cex=0.8)
    }
  }
  lines(1:n,n:1,col="darkgrey")
  mtext(rownames(m),side=2,line=1,at=n:1,las=2)
  mtext(colnames(m),side=3,line=1, at=1:n, las=2)
}

############################################################################
# function that carries out all steps to obtain adjacency matrix with
# a (hopefully) minimal number of violations
#   it adds a backward reordering (not reported in Baayen/Plag 2008), and
#   returns a list with average ranks, an optimal adjacency matrix,
#   and a data frame with affixes in columns and orderings in rows
# adjacency matrix and figure are exported to local directory
# WARNING: in the paper, a more complex search is reported in which the
# starting matrix (here the sorted matrix) is randomized 10,000 times, and
# the search algorithm with only forward search is applied.  That gives 
# rise to a similar but not identical affix ranking; 
# see sampleAdjacencySpace.fnc
############################################################################

analysis.fnc = function(newmat=NA) {
  errorValues = numeric()
  if (is.na(newmat)) mOrig = loadData.fnc()
  else mOrig=newmat
  errorValues[1] = sum(mOrig[lower.tri(mOrig)]!=0)
  mSorted = sortByColTotal.fnc(mOrig)
  errorValues[2] = sum(mSorted[lower.tri(mSorted)]!=0)
  x = moveRight.fnc(mat=mSorted)
  errorValues[3] = x$errorCount
  # optimize
  i=3
  while (!is.na(x[1])) {
    mm = x$m
    x = moveRight.fnc(mat=mm)
    i = i+1
    errorValues[i] = x$errorCount
    if (i > 10) 
      if (length(table(errorValues[i:(i-10+1)])) == 1) break
  }
  errorValues
  mmm = x$m
  cat("optimized error count is ", sum(mmm[lower.tri(mmm)]!=0), "\n")

  # estimate alternative orders with forward search
  y = moveRight.fnc(mat=x$m, lessOrEqual=FALSE, forward=TRUE)
  vec = y$vectorOfOrders
  vec2 = numeric()
  for (i in 1:100) {
    mm = y$m
    y = moveRight.fnc(mat=mm, lessOrEqual=FALSE)
    vec = c(vec, y$vectorOfOrders)
    vec2[i] = length(table(vec))
    #cat(i, vec2[i], "\n")
    if (i > 10) 
      if (length(table(vec2[i:(i-10+1)])) == 1) break
  }
  cat("completed forward search, found ", vec2[i], "alternative orderings\n")
  
  # estimate alternative orders with backward search
  # using original model with lessOrEqual==TRUE
  y = moveRight.fnc(mat=mmm, lessOrEqual=FALSE,forward=FALSE)
  vec = c(vec, y$vectorOfOrders)
  for (i in 1:500) {
    mm = y$m
    y = moveRight.fnc(mat=mm, lessOrEqual=FALSE,forward=FALSE)
    vec = c(vec, y$vectorOfOrders)
    vec2[i] = length(table(vec))
    if (i > 10) 
      if (length(table(vec2[i:(i-10+1)])) == 1) break
  }
  cat("completed backward search, found in all ", vec2[i], "alternative orderings\n")
  
  # calculate average rank of suffix in each order
  orders = names(table(vec))
  aff = sort(colnames(mm))
  for (i in 1:length(orders)) {
    ord = strsplit(orders[i], " ")[[1]]
    v = 1:length(ord)
    names(v) = ord
    v = v[order(names(v))]
    if (i == 1) {
      dfr = data.frame(affixes=aff, v)
    } else {
      dfr = cbind(dfr, v)
    }
  }
  dfr = data.frame(dfr)
  meanranks = sort(apply(dfr[,2:ncol(dfr)], 1, mean))
  meanranks = data.frame(affix=names(meanranks), rank=as.numeric(meanranks))
  cat("completed averaging ranks\n")
  cat("showing final model, and saving it as orderingAutomatic.pdf\n")
  plotmat.fnc(mmm)
  pdf("orderingAutomatic.pdf", he=7,width=7)
  plotmat.fnc(mmm)
  dev.off()
  cat("mean rank table saved as orderingAutomatic.txt\n")
  write.table(meanranks, file="orderingAutomatic.txt", quote=F, row.names=F)
  totorders = exp(lgamma(32))
  cat("total number of orderings is ", totorders, "\n")

  return(list(dfr=dfr, meanranks=meanranks, m=mmm))
}


############################################################################
# a function sorting an adjacency matrix by column totals
# it also plots the sorted matrix, and reports the count of exceptions below
# the diagonal
############################################################################

sortByColTotal.fnc = function(m) {
  mOrig = m
  coltotals = apply(mOrig, 2, sum)
  mSorted = mOrig[order(coltotals), order(coltotals)]
  rownames(mSorted) = rownames(mOrig)[order(coltotals)]
  colnames(mSorted) = colnames(mOrig)[order(coltotals)]
  plotmat.fnc(mSorted)
  errorCount = sum(mSorted[lower.tri(mSorted)]!=0)
  cat("error count after sorting is ", errorCount, "\n")
  return(mSorted)
}

############################################################################
# This function attempts to minimize the number of exceptions below the diag.
# For each suffix, it first calculates what its optimal position (to the right
# of another suffix) might be.  Following this scan, the adjacency matrix is
# reordered using a greedy strategy in which the most successful move is
# executed first.  Moves are only executed if they do not lead to more
# violations. (Moves that looked good in the first pass may not be good anymore
# when higher-ranked changes have taken effect.)
############################################################################

moveRight.fnc = function(mat, lessOrEqual=TRUE, plot=FALSE, forward=TRUE) {
  m = mat
  n = ncol(m)
  # make a list of possibly potentially useful moves rightward
  errorCount = sum(m[lower.tri(m)]!=0)
  res = list()
  rescnt = 0
  if (forward) {
    direction = 1:(n-1)
  } else {
    direction = (n-1):1
  }
  for (pos in direction) {
    errors = rep(-1, n)
    for (i in (pos+1):n) {
      m2 = m
      m2 = insert.fnc(m2, pos, i)
      errors[i] = sum(m2[lower.tri(m2)]!=0)
    }
    minpos = which(errors==min(errors[(pos+1):n]) & errors > -1)
    if (length(minpos) > 1) minpos=max(minpos)
    if (lessOrEqual==FALSE) {
      condition = ((errors[minpos] == errorCount) & (minpos > pos))
    } else {
      condition = ((errors[minpos] <= errorCount) & (minpos > pos))
    }
    if (condition) {
      m2 = insert.fnc(m, pos, minpos)
      newErrorCount = sum(m2[lower.tri(m2)]!=0)
      rescnt = rescnt+1
      res[[rescnt]] = list(errorCount = newErrorCount, pos=pos, after=minpos, 
        af1=rownames(m)[pos],af2=rownames(m)[minpos])
    }      
  }

  if (length(res) > 0) {
    #  apply the most beneficial change first, 
    # add changes iff they do not increase the errorCount
    minima = rep(0, length(res))
    for (i in 1:length(res)) {
      minima[i] = res[[i]]$errorCount
    }
    ordering = order(minima)
    if (lessOrEqual==FALSE) {
      vectorOfOrders = character()
    } else {
      vectorOfOrders = NA
    }
    for (i in 1:length(ordering)) {
      r = res[[ordering[i]]]
      af1pos = which(colnames(m) == r$af1)
      af2pos = which(colnames(m) == r$af2)
      m2 = m
      m2 = insert.fnc(m2, af1pos, af2pos)
      newErrorCount = sum(m2[lower.tri(m2)]!=0)
      if (lessOrEqual==FALSE) {
        condition = newErrorCount == errorCount
      } else {
        condition = newErrorCount <= errorCount
      }
      if (condition) {
        m = m2
        errorCount = newErrorCount
        if (lessOrEqual==FALSE){
          ord = paste(colnames(m), collapse=" ")
          vectorOfOrders = c(vectorOfOrders, ord)
        }
      }
    }
    if (plot) plotmat.fnc(m)
    return(list(m=m, res=res, errorCount=errorCount, vectorOfOrders = vectorOfOrders))
  } else {
    cat("no further optimization possible\n")
    return(NA)
  }
}

############################################################################
# function inserting af1 after af2 in the adjacency matrix columns and rows
############################################################################

insert.fnc = function(mat, af1, af2) {
    # insert af1 after af2, and remove original row+column
    if (af2 <= af1) stop("insertion only after columns to the right\n")

    x = mat
		names = rownames(x)

    if (af1 == 1) {
      if (af2 < ncol(mat)) {
        v = c(2:af2, af1, (af2+1):ncol(x))
      } else {
        v = c(2:af2, af1)
      }
    } else {
      if (af2 < ncol(mat)) {
        v = c(1:(af1-1), (af1+1):af2, af1, (af2+1):ncol(x))
      } else {
        v = c(1:(af1-1), (af1+1):af2, af1)
      }
    }

    # columns
    x = x[,v]
    # rows
    x = x[v,]
    # labels
    names = names[v]
		rownames(x) = names
		colnames(x) = names

    return(x)
}

##############################################################################
# a simple matrix to check that insert.fnc works properly
##############################################################################
#   
#   
#   z = matrix(c("a1","a2","a3","a4","b1","b2","b3","b4","c1","c2","c3","c4",
#   "d1","d2","d3","d4"),4,4)
#   colnames(z) = c("A","B", "C", "D")
#   rownames(z) = c("A","B", "C", "D")
#   insert.fnc(z,1,3)
#   insert.fnc(z,1,4)
#   insert.fnc(z,2,3)
#   insert.fnc(z,3,4)
#
#
##############################################################################




############################################################################
# randomize order of colums (and corresponding rows) in adjacency matrix mat
############################################################################
randomizeMatrix.fnc = function(mat) {
  rand = sample(1:ncol(mat))
  m = mat
  m = m[,rand]
  m = m[rand,]
  return(m)
}




############################################################################
# sample the space of possible minimal orderings by taking random matrix as
# starting point; mOrig is original data as obtained with loadData.fnc()
############################################################################
sampleAdjacencySpace.fnc = function(mOrig){

  stop("remove the stop line from the code to run this\n")
  # don't run, takes a lot of time, objects produced are dfr.rda 
  # and permutations.rda

  minErrorValues = numeric()
  permutations = list()
  for (run in 1:10000) {
    errorValues=numeric()
    m=randomizeMatrix.fnc(mOrig)
    errorValues[1] = sum(mOrig[lower.tri(mOrig)]!=0)
    errorValues[2] = errorValues[1]
    x = moveRight.fnc(mat=m)
    errorValues[3] = x$errorCount
    i=3
    while (!is.na(x[1])) {
      mm = x$m
      x = moveRight.fnc(mat=mm)
      i = i+1
      errorValues[i] = x$errorCount
      if (i > 10) 
        if (length(table(errorValues[i:(i-10+1)])) == 1) break
    }
    errorValues
    mmm = x$m
    minErrorValues[run] = sum(mmm[lower.tri(mmm)]!=0)
    permutations[[run]] = colnames(mmm)
    if ((run %% 100) == 0) cat(".")
  }
  cat("\n")
  dfr = data.frame(minima = min(minErrorValues), 
    positions = which(minErrorValues == min(minErrorValues)))

  # it could be useful to save the data objects independently from .RData
  # save(dfr, file="dfr.rda")
  # save(permutations, file="permutations.rda")

  return(list(dfr=dfr, permutations=permutations))
}
