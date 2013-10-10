
# install.packages(c("RTextTools","topicmodels"))
library(RTextTools)
library(topicmodels)

"Step 2: Load the Data"
data(NYTimes)
data <- NYTimes[sample(1:3100,size=1000,replace=FALSE),]

"Step 3: Create a Docum  entTermMatrix"

matrix <- create_matrix(cbind(as.vector(data$Title),as.vector(data$Subject)), 
                        language="english", 
                        removeNumbers=TRUE, 
                        stemWords=TRUE, 
                        weighting=weightTf)

"Step 4: Perform Latent Dirichlet Allocation"

k <- length(unique(data$Topic.Code))
lda <- LDA(matrix, k)

"Step 5: View the Results"

terms(lda, 5)
terms(lda)

topics(lda)