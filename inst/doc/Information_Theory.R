## ----eval=FALSE----------------------------------------------------------
#  # define probabilities P(X)
#  Prob <- 1:10/sum(1:10)
#  # Compute Shannon's Entropy
#  H(Prob)

## ----eval=FALSE----------------------------------------------------------
#  # define the joint distribution P(X,Y)
#  P_xy <- 1:100/sum(1:100)
#  # Compute Shannon's Joint-Entropy
#  JE(P_xy)

## ----eval=FALSE----------------------------------------------------------
#  # define the distribution P(X)
#  P_x <- 1:10/sum(1:10)
#  # define the distribution P(Y)
#  P_y <- 11:20/sum(11:20)
#  
#  # Compute Shannon's Joint-Entropy
#  CE(P_x,P_y)

