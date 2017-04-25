## ----eval=FALSE----------------------------------------------------------
#  # define a probability density function P
#  P <- 1:10/sum(1:10)
#  # define a probability density function Q
#  Q <- 20:29/sum(20:29)
#  
#  # combine P and Q as matrix object
#  x <- rbind(P,Q)

## ----eval=FALSE----------------------------------------------------------
#  library(philentropy)
#  
#  # compute the Euclidean Distance with default parameters
#  distance(x, method = "euclidean")

## ----eval=FALSE----------------------------------------------------------
#  # compute the Euclidean Distance using R's base function
#  stats::dist(x, method = "euclidean")

## ----eval=FALSE----------------------------------------------------------
#  # names of implemented distance/similarity functions
#  getDistMethods()

## ----eval=FALSE----------------------------------------------------------
#  # compute the Jaccard Distance with default parameters
#  distance(x, method = "jaccard")

## ----eval=FALSE----------------------------------------------------------
#  # combine three probabilty vectors to a probabilty matrix
#  ProbMatrix <- rbind(1:10/sum(1:10), 20:29/sum(20:29),30:39/sum(30:39))
#  
#  # compute the euclidean distance between all
#  # pairwise comparisons of probability vectors
#  distance(ProbMatrix, method = "euclidean")

## ----eval=FALSE----------------------------------------------------------
#  # compute the euclidean distance between all
#  # pairwise comparisons of probability vectors
#  # using stats::dist()
#  stats::dist(ProbMatrix, method = "euclidean")

## ----eval=FALSE----------------------------------------------------------
#  # install.packages("microbenchmark")
#  library(microbenchmark)
#  
#  microbenchmark(
#    distance(x,method = "euclidean", test.na = FALSE),
#    dist(x,method = "euclidean"),
#    euclidean(x[1 , ], x[2 , ], FALSE)
#  )

