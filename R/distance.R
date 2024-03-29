#  Part of the philentropy package
#
#  Copyright (C) 2015-2021 Hajk-Georg Drost
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  A copy of the GNU General Public License is available at
#  http://www.r-project.org/Licenses/




#' @title Distances and Similarities between Probability Density Functions
#' @description This functions computes the distance/dissimilarity between two probability density functions.
#' @param x a numeric \code{data.frame} or \code{matrix} (storing probability vectors) or a numeric \code{data.frame} or \code{matrix} storing counts (if \code{est.prob} is specified).
#' @param method a character string indicating whether the distance measure that should be computed.
#' @param p power of the Minkowski distance.
#' @param test.na a boolean value indicating whether input vectors should be tested for \code{NA} values. Faster computations if \code{test.na = FALSE}.
#' @param unit a character string specifying the logarithm unit that should be used to compute distances that depend on log computations.
#' @param epsilon a small value to address cases in the distance computation where division by zero occurs. In
#' these cases, x / 0 or 0 / 0 will be replaced by \code{epsilon}. The default is \code{epsilon = 0.00001}.
#' However, we recommend to choose a custom \code{epsilon} value depending on the size of the input vectors,
#' the expected similarity between compared probability density functions and 
#' whether or not many 0 values are present within the compared vectors.
#' As a rough rule of thumb we suggest that when dealing with very large 
#' input vectors which are very similar and contain many \code{0} values,
#' the \code{epsilon} value should be set even smaller (e.g. \code{epsilon = 0.000000001}),
#' whereas when vector sizes are small or distributions very divergent then
#' higher \code{epsilon} values may also be appropriate (e.g. \code{epsilon = 0.01}).
#' Addressing this \code{epsilon} issue is important to avoid cases where distance metrics
#' return negative values which are not defined and only occur due to the
#' technical issues of computing x / 0 or 0 / 0 cases.
#' @param est.prob method to estimate probabilities from input count vectors such as non-probability vectors. Default: \code{est.prob = NULL}. Options are:
#' \itemize{
#' \item \code{est.prob = "empirical"}: The relative frequencies of each vector are computed internally. For example an input matrix \code{rbind(1:10, 11:20)} will be transformed to a probability vector \code{rbind(1:10 / sum(1:10), 11:20 / sum(11:20))}
#' }
#' @param use.row.names a logical value indicating whether or not row names from
#' the input matrix shall be used as rownames and colnames of the output distance matrix. Default value is \code{use.row.names = FALSE}.
#' @param as.dist.obj shall the return value or matrix be an object of class \code{link[stats]{dist}}? Default is \code{as.dist.obj = FALSE}.
#' @param diag if \code{as.dist.obj = TRUE}, then this value indicates whether the diagonal of the distance matrix should be printed. Default
#' @param upper if \code{as.dist.obj = TRUE}, then this value indicates whether the upper triangle of the distance matrix should be printed.
#' @param mute.message a logical value indicating whether or not messages printed by \code{distance} shall be muted. Default is \code{mute.message = FALSE}.
#' @author Hajk-Georg Drost
#' @details
#' Here a distance is defined as a quantitative degree of how far two mathematical objects are apart from eachother (Cha, 2007).
#'
#' This function implements the following distance/similarity measures to quantify the distance between probability density functions:
#'
#'
#' \itemize{
#' \item L_p Minkowski family
#' \itemize{
#' \item Euclidean : \eqn{d = sqrt( \sum | P_i - Q_i |^2)}
#' \item Manhattan : \eqn{d = \sum | P_i - Q_i |}
#' \item Minkowski : \eqn{d = ( \sum | P_i - Q_i |^p)^1/p}
#' \item Chebyshev : \eqn{d = max | P_i - Q_i |}
#' }
#'
#' \item L_1 family
#' \itemize{
#' \item Sorensen : \eqn{d = \sum | P_i - Q_i | / \sum (P_i + Q_i)}
#' \item Gower : \eqn{d = 1/d * \sum | P_i - Q_i |}
#' \item Soergel : \eqn{d = \sum | P_i - Q_i | / \sum max(P_i , Q_i)}
#' \item Kulczynski d : \eqn{d = \sum | P_i - Q_i | / \sum min(P_i , Q_i)}
#' \item Canberra : \eqn{d = \sum | P_i - Q_i | / (P_i + Q_i)}
#' \item Lorentzian : \eqn{d = \sum ln(1 + | P_i - Q_i |)}
#' }
#'
#'
#' \item Intersection family
#' \itemize{
#' \item Intersection : \eqn{s = \sum min(P_i , Q_i)}
#' \item Non-Intersection : \eqn{d = 1 - \sum min(P_i , Q_i)}
#' \item Wave Hedges : \eqn{d = \sum | P_i - Q_i | / max(P_i , Q_i)}
#' \item Czekanowski : \eqn{d = \sum | P_i - Q_i | / \sum | P_i + Q_i |}
#' \item Motyka : \eqn{d = \sum min(P_i , Q_i) / (P_i + Q_i)}
#' \item Kulczynski s : \eqn{d = 1 / \sum | P_i - Q_i | / \sum min(P_i , Q_i)}
#' \item Tanimoto : \eqn{d = \sum (max(P_i , Q_i) - min(P_i , Q_i)) / \sum max(P_i , Q_i)} ; equivalent to Soergel
#' \item Ruzicka : \eqn{s = \sum min(P_i , Q_i) / \sum max(P_i , Q_i)} ; equivalent to 1 - Tanimoto = 1 - Soergel
#' }
#'
#' \item Inner Product family
#' \itemize{
#' \item Inner Product : \eqn{s = \sum P_i * Q_i}
#' \item Harmonic mean : \eqn{s = 2 * \sum (P_i * Q_i) / (P_i + Q_i)}
#' \item Cosine : \eqn{s = \sum (P_i * Q_i) / sqrt(\sum P_i^2) * sqrt(\sum Q_i^2)}
#' \item Kumar-Hassebrook (PCE) : \eqn{s = \sum (P_i * Q_i) / (\sum P_i^2 + \sum Q_i^2 - \sum (P_i * Q_i))}
#' \item Jaccard : \eqn{d = 1 - \sum (P_i * Q_i) / (\sum P_i^2 + \sum Q_i^2 - \sum (P_i * Q_i))} ; equivalent to 1 - Kumar-Hassebrook
#' \item Dice : \eqn{d = \sum (P_i - Q_i)^2 / (\sum P_i^2 + \sum Q_i^2)}
#' }
#'
#' \item Squared-chord family
#' \itemize{
#' \item Fidelity : \eqn{s = \sum sqrt(P_i * Q_i)}
#' \item Bhattacharyya : \eqn{d = - ln \sum sqrt(P_i * Q_i)}
#' \item Hellinger : \eqn{d = 2 * sqrt( 1 - \sum sqrt(P_i * Q_i))}
#' \item Matusita : \eqn{d = sqrt( 2 - 2 * \sum sqrt(P_i * Q_i))}
#' \item Squared-chord : \eqn{d = \sum ( sqrt(P_i) - sqrt(Q_i) )^2}
#' }
#'
#'
#' \item Squared L_2 family (\eqn{X}^2 squared family)
#' \itemize{
#' \item Squared Euclidean : \eqn{d = \sum ( P_i - Q_i )^2}
#' \item Pearson \eqn{X}^2 : \eqn{d = \sum ( (P_i - Q_i )^2 / Q_i )}
#' \item Neyman \eqn{X}^2 : \eqn{d = \sum ( (P_i - Q_i )^2 / P_i )}
#' \item Squared \eqn{X}^2 : \eqn{d = \sum ( (P_i - Q_i )^2 / (P_i + Q_i) )}
#' \item Probabilistic Symmetric \eqn{X}^2 : \eqn{d = 2 *  \sum ( (P_i - Q_i )^2 / (P_i + Q_i) )}
#' \item Divergence : \eqn{X}^2 : \eqn{d = 2 *  \sum ( (P_i - Q_i )^2 / (P_i + Q_i)^2 )}
#' \item Clark : \eqn{d = sqrt ( \sum (| P_i - Q_i | / (P_i + Q_i))^2 )}
#' \item Additive Symmetric \eqn{X}^2 : \eqn{d = \sum ( ((P_i - Q_i)^2 * (P_i + Q_i)) / (P_i * Q_i) ) }
#' }
#'
#' \item Shannon's entropy family
#' \itemize{
#' \item Kullback-Leibler : \eqn{d = \sum P_i * log(P_i / Q_i)}
#' \item Jeffreys : \eqn{d = \sum (P_i - Q_i) * log(P_i / Q_i)}
#' \item K divergence : \eqn{d = \sum P_i * log(2 * P_i / P_i + Q_i)}
#' \item Topsoe : \eqn{d = \sum ( P_i * log(2 * P_i / P_i + Q_i) ) + ( Q_i * log(2 * Q_i / P_i + Q_i) )}
#' \item Jensen-Shannon :  \eqn{d = 0.5 * ( \sum P_i * log(2 * P_i / P_i + Q_i) + \sum Q_i * log(2 * Q_i / P_i + Q_i))}
#' \item Jensen difference : \eqn{d = \sum ( (P_i * log(P_i) + Q_i * log(Q_i) / 2) - (P_i + Q_i / 2) * log(P_i + Q_i / 2) )}
#' }
#'
#' \item Combinations
#' \itemize{
#' \item Taneja : \eqn{d = \sum ( P_i + Q_i / 2) * log( P_i + Q_i / ( 2 * sqrt( P_i * Q_i)) )}
#' \item Kumar-Johnson : \eqn{d = \sum (P_i^2 - Q_i^2)^2 / 2 * (P_i * Q_i)^1.5}
#' \item Avg(L_1, L_n) : \eqn{d = \sum | P_i - Q_i| + max{ | P_i - Q_i |} / 2}
#' }
#'
#' In cases where \code{x} specifies a count matrix, the argument \code{est.prob} can be selected to first estimate probability vectors
#' from input count vectors and second compute the corresponding distance measure based on the estimated probability vectors.
#'
#'  The following probability estimation methods are implemented in this function:
#'
#'  \itemize{
#'  \item \code{est.prob = "empirical"} : relative frequencies of counts.
#'  }
#' }
#' @examples
#' # Simple Examples
#'
#' # receive a list of implemented probability distance measures
#' getDistMethods()
#'
#' ## compute the euclidean distance between two probability vectors
#' distance(rbind(1:10/sum(1:10), 20:29/sum(20:29)), method = "euclidean")
#'
#' ## compute the euclidean distance between all pairwise comparisons of probability vectors
#' ProbMatrix <- rbind(1:10/sum(1:10), 20:29/sum(20:29),30:39/sum(30:39))
#' distance(ProbMatrix, method = "euclidean")
#'
#' # compute distance matrix without testing for NA values in the input matrix
#' distance(ProbMatrix, method = "euclidean", test.na = FALSE)
#'
#' # alternatively use the colnames of the input data for the rownames and colnames
#' # of the output distance matrix
#' ProbMatrix <- rbind(1:10/sum(1:10), 20:29/sum(20:29),30:39/sum(30:39))
#' rownames(ProbMatrix) <- paste0("Example", 1:3)
#' distance(ProbMatrix, method = "euclidean", use.row.names = TRUE)
#'
#' # Specialized Examples
#'
#' CountMatrix <- rbind(1:10, 20:29, 30:39)
#'
#' ## estimate probabilities from a count matrix
#' distance(CountMatrix, method = "euclidean", est.prob = "empirical")
#'
#' ## compute the euclidean distance for count data
#' ## NOTE: some distance measures are only defined for probability values,
#' distance(CountMatrix, method = "euclidean")
#'
#' ## compute the Kullback-Leibler Divergence with different logarithm bases:
#' ### case: unit = log (Default)
#' distance(ProbMatrix, method = "kullback-leibler", unit = "log")
#'
#' ### case: unit = log2
#' distance(ProbMatrix, method = "kullback-leibler", unit = "log2")
#'
#' ### case: unit = log10
#' distance(ProbMatrix, method = "kullback-leibler", unit = "log10")
#'
#' @note According to the reference in some distance measure computations invalid computations can
#' occur when dealing with 0 probabilities.
#'
#' In these cases the convention is treated as follows:
#'
#' \itemize{
#' \item division by zero - case \code{0/0}: when the divisor and dividend become zero, \code{0/0} is treated as \code{0}.
#' \item division by zero - case \code{n/0}: when only the divisor becomes \code{0}, the corresponsning \code{0} is replaced by a small \eqn{\epsilon = 0.00001}.
#' \item log of zero - case \code{0 * log(0)}: is treated as \code{0}.
#' \item log of zero - case \code{log(0)}: zero is replaced by a small \eqn{\epsilon = 0.00001}.
#' }
#'
#' @references Sung-Hyuk Cha. (2007). \emph{Comprehensive Survey on Distance/Similarity Measures between Probability Density Functions}. International Journal of Mathematical Models and Methods in Applied Sciences 4: 1.
#' @return
#' The following results are returned depending on the dimension of \code{x}:
#'
#' \itemize{
#' \item in case \code{nrow(x)} = 2 : a single distance value.
#' \item in case \code{nrow(x)} > 2 : a distance \code{matrix} storing distance values for all pairwise probability vector comparisons.
#' }
#' @seealso \code{\link{getDistMethods}}, \code{\link{estimate.probability}}, \code{\link{dist.diversity}}
#' @export

distance <- function(x ,
                     method      = "euclidean",
                     p           = NULL,
                     test.na     = TRUE,
                     unit        = "log",
                     epsilon     = 0.00001,
                     est.prob    = NULL,
                     use.row.names = FALSE,
                     as.dist.obj = FALSE,
                     diag = FALSE,
                     upper = FALSE,
                     mute.message = FALSE) {
  if (!any(is.element(
    class(x),
    c(
      "data.frame",
      "matrix",
      "data.table",
      "tbl_df",
      "tbl",
      "array"
    )
  )))
    stop("x should be a data.frame, data.table, tbl, tbl_df, array, or matrix.",
         call. = FALSE)
  
  if (is.character(x))
    stop(
      paste0(
        "Your input ",
        class(x)[1],
        " stores non-numeric values. Non numeric values cannot be used to compute distances.."
      ),
      call = FALSE
    )
  
  
  dist_methods <- vector(mode = "character", length = 46)
  dist_methods <-
    c(
      "euclidean",
      "manhattan",
      "minkowski",
      "chebyshev",
      "sorensen",
      "gower",
      "soergel",
      "kulczynski_d",
      "canberra",
      "lorentzian",
      "intersection",
      "non-intersection",
      "wavehedges",
      "czekanowski",
      "motyka",
      "kulczynski_s",
      "tanimoto",
      "ruzicka",
      "inner_product",
      "harmonic_mean",
      "cosine",
      "hassebrook",
      "jaccard",
      "dice",
      "fidelity",
      "bhattacharyya",
      "hellinger",
      "matusita",
      "squared_chord",
      "squared_euclidean",
      "pearson",
      "neyman",
      "squared_chi",
      "prob_symm",
      "divergence",
      "clark",
      "additive_symm",
      "kullback-leibler",
      "jeffreys",
      "k_divergence",
      "topsoe",
      "jensen-shannon",
      "jensen_difference",
      "taneja",
      "kumar-johnson",
      "avg"
    )
  
  # if (tibble::has_rownames(x) & use.row.names) {
  #   remember_row_names <- row.names(x)
  #   x <- tibble::remove_rownames(x)
  # }
  
  # transpose the matrix or data.frame
  # in case of DF: DF is transformed to matrix by t()
  x <- t(x)
  
  # number of input probability vectors
  ncols <- vector("numeric", 1)
  ncols <- ncol(x)
  
  if (!is.element(method, dist_methods))
    stop(
      "Method '",
      method,
      "' is not implemented in this function. Please consult getDistMethods().",
      call. = FALSE
    )
  
  if (!is.null(est.prob)) {
    x <- apply(x, 2, estimate.probability, method = est.prob)
  }
  
  if (!is.element(unit, c("log", "log2", "log10")))
    stop("You can only choose units: log, log2, or log10.", call. = FALSE)
  
  # although validation would be great, it cost a lot of computation time
  # for large comparisons between multiple distributions
  # here a smarter (faster) way to validate distributions needs to be implemented
  #         if(check.distr){
  #                 # check for distribution validity
  #                 apply(x,2,valid.distr)
  #         }
  
  if (ncols == 2) {
    dist <- vector("numeric", 1)
    } else {
    dist <- matrix(NA_real_, ncols, ncols)
  }
  
  # message("Metric: '", method, "' using unit: '", unit, "'.")
  
  
  if (method == "euclidean") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    
    if (ncols == 2) {
      dist <- euclidean(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
      
    }

    if (ncols > 2)
      dist <-
        DistMatrixNoUnit(x, euclidean, test.na)
  }
  
  else if (method == "manhattan") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    
    if (ncols == 2)
      dist <- manhattan(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <-
        DistMatrixNoUnit(x, manhattan, test.na)
    
  }
  
  else if (method == "minkowski") {
    if (!mute.message)
      message("Metric: '",
              method,
              "'; p = ",
              p,
              "; comparing: ",
              ncols,
              " vectors.")
    
    if (!is.null(p)) {
      if (ncols == 2)
        dist <-
          minkowski(as.numeric(x[, 1]), as.numeric(x[, 2]), as.double(p), test.na)
      if (ncols > 2)
        dist <-
          DistMatrixMinkowski(x, as.double(p), test.na)
    } else {
      stop("Please specify p for the Minkowski distance.", call. = FALSE)
    }
  }
  
  else if (method == "chebyshev") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <- chebyshev(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <-
        DistMatrixNoUnit(x, chebyshev, test.na)
  }
  
  else if (method == "sorensen") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <- sorensen(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <- DistMatrixNoUnit(x, sorensen, test.na)
    
  }
  
  else if (method == "gower") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <- gower(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <- DistMatrixNoUnit(x, gower, test.na)
  }
  
  else if (method == "soergel") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <- soergel(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <- DistMatrixNoUnit(x, soergel, test.na)
  }
  
  else if (method == "kulczynski_d") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <-
        kulczynski_d(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na, epsilon)
    
    if (ncols > 2)
      dist <-
        DistMatrixNoUnit_epsilon(x, kulczynski_d, test.na, epsilon)
  }
  
  else if (method == "canberra") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <- canberra(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <- DistMatrixNoUnit(x, canberra, test.na)
  }
  
  else if (method == "lorentzian") {
    if (!mute.message)
      message("Metric: '",
              method,
              "' using unit: '",
              unit,
              "'; comparing: ",
              ncols,
              " vectors.")
    if (ncols == 2)
      dist <-
        lorentzian(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na, unit)
    if (ncols > 2)
      dist <-
        DistMatrix(x, lorentzian, test.na, unit)
  }
  
  else if (method == "intersection") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <-
        intersection_dist(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <-
        DistMatrixNoUnit(x, intersection_dist, test.na)
    
  }
  
  else if (method == "non-intersection") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <-
        1.0 - intersection_dist(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <-
        1.0 - DistMatrixNoUnit(x, intersection_dist, test.na)
  }
  
  else if (method == "wavehedges") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <-
        wave_hedges(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <-
        DistMatrixNoUnit(x, wave_hedges, test.na)
    
  }
  
  else if (method == "czekanowski") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <-
        czekanowski(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <-
        DistMatrixNoUnit(x, czekanowski, test.na)
  }
  
  else if (method == "motyka") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <- motyka(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <- DistMatrixNoUnit(x, motyka, test.na)
  }
  
  else if (method == "kulczynski_s") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <-
        1.0 / kulczynski_d(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na, epsilon)
    
    if (ncols > 2)
      dist <-
        1.0 / DistMatrixNoUnit_epsilon(x, kulczynski_d, test.na, epsilon)
  }
  
  else if (method == "tanimoto") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <- tanimoto(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <- DistMatrixNoUnit(x, tanimoto, test.na)
  }
  
  else if (method == "ruzicka") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <- ruzicka(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <- DistMatrixNoUnit(x, ruzicka, test.na)
  }
  
  else if (method == "inner_product") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <-
        inner_product(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <-
        DistMatrixNoUnit(x, inner_product, test.na)
  }
  
  else if (method == "harmonic_mean") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <-
        harmonic_mean_dist(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <-
        DistMatrixNoUnit(x, harmonic_mean_dist, test.na)
    
  }
  
  else if (method == "cosine") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <-
        cosine_dist(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <-
        DistMatrixNoUnit(x, cosine_dist, test.na)
    
  }
  
  else if (method == "hassebrook") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <-
        kumar_hassebrook(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <-
        DistMatrixNoUnit(x, kumar_hassebrook, test.na)
    
  }
  
  else if (method == "jaccard") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <- jaccard(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <- DistMatrixNoUnit(x, jaccard, test.na)
    
  }
  
  else if (method == "dice") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <- dice_dist(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <-
        DistMatrixNoUnit(x, dice_dist, test.na)
    
  }
  
  else if (method == "fidelity") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <- fidelity(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <- DistMatrixNoUnit(x, fidelity, test.na)
  }
  
  else if (method == "bhattacharyya") {
    if (!mute.message)
      message("Metric: '",
              method,
              "' using unit: '",
              unit,
              "'; comparing: ",
              ncols,
              " vectors.")
    if (ncols == 2)
      dist <-
        bhattacharyya(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na, unit, epsilon)
    if (ncols > 2)
      dist <-
        DistMatrix_epsilon(x, bhattacharyya, test.na, unit, epsilon)
  }
  
  else if (method == "hellinger") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <- hellinger(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <-
        DistMatrixNoUnit(x, hellinger, test.na)
  }
  
  else if (method == "matusita") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    
    if (any(colSums(x) > 1.00001))
      stop("Please make sure that all vectors sum up to 1.0 ...", call. = FALSE)
    
    if (ncols == 2)
      dist <- matusita(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <- DistMatrixNoUnit(x, matusita, test.na)
  }
  
  else if (method == "squared_chord") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <-
        squared_chord(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <-
        DistMatrixNoUnit(x, squared_chord, test.na)
  }
  
  else if (method == "squared_euclidean") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <-
        squared_euclidean(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <-
        DistMatrixNoUnit(x, squared_euclidean, test.na)
  }
  
  else if (method == "pearson") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <-
        pearson_chi_sq(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na, epsilon)
    
    if (ncols > 2)
      dist <-
        DistMatrixNoUnit_epsilon(x, pearson_chi_sq, test.na, epsilon)
    
  }
  
  else if (method == "neyman") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <-
        neyman_chi_sq(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na, epsilon)
    
    if (ncols > 2)
      dist <-
        DistMatrixNoUnit_epsilon(x, neyman_chi_sq, test.na, epsilon)
    
  }
  
  else if (method == "squared_chi") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <-
        squared_chi_sq(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <-
        DistMatrixNoUnit(x, squared_chi_sq, test.na)
    
  }
  
  else if (method == "prob_symm") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <-
        prob_symm_chi_sq(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <-
        DistMatrixNoUnit(x, prob_symm_chi_sq, test.na)
    
  }
  
  else if (method == "divergence") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <-
        divergence_sq(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <-
        DistMatrixNoUnit(x, divergence_sq, test.na)
    
  }
  
  else if (method == "clark") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <- clark_sq(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <- DistMatrixNoUnit(x, clark_sq, test.na)
    
  }
  
  else if (method == "additive_symm") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <-
        additive_symm_chi_sq(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    
    if (ncols > 2)
      dist <-
        DistMatrixNoUnit(x, additive_symm_chi_sq, test.na)
    
  }
  
  else if (method == "kullback-leibler") {
    if (!mute.message)
      message("Metric: '",
              method,
              "' using unit: '",
              unit,
              "'; comparing: ",
              ncols,
              " vectors.")
    if (any(colSums(x) > 1.00001))
      stop("Please make sure that all vectors sum up to 1.0 ...", call. = FALSE)
    
    if (ncols == 2)
      dist <-
        kullback_leibler_distance(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na, unit, epsilon)
    if (ncols > 2)
      dist <-
        DistMatrix_epsilon(x, kullback_leibler_distance, test.na, unit, epsilon)
  }
  
  else if (method == "jeffreys") {
    if (!mute.message)
      message("Metric: '",
              method,
              "' using unit: '",
              unit,
              "'; comparing: ",
              ncols,
              " vectors.")
    if (ncols == 2)
      dist <-
        jeffreys(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na, unit, epsilon)
    if (ncols > 2)
      dist <- DistMatrix_epsilon(x, jeffreys, test.na, unit, epsilon)
    
  }
  
  else if (method == "k_divergence") {
    if (!mute.message)
      message("Metric: '",
              method,
              "' using unit: '",
              unit,
              "'; comparing: ",
              ncols,
              " vectors.")
    if (any(colSums(x) > 1.00001))
      stop("Please make sure that all vectors sum up to 1.0 ...", call. = FALSE)
    
    if (ncols == 2)
      dist <-
        k_divergence(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na, unit)
    if (ncols > 2)
      dist <-
        DistMatrix(x, k_divergence, test.na, unit)
  }
  
  else if (method == "topsoe") {
    if (!mute.message)
      message("Metric: '",
              method,
              "' using unit: '",
              unit,
              "'; comparing: ",
              ncols,
              " vectors.")
    if (ncols == 2)
      dist <-
        topsoe(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na, unit)
    if (ncols > 2)
      dist <- DistMatrix(x, topsoe, test.na, unit)
    
  }
  
  else if (method == "jensen-shannon") {
    if (!mute.message)
      message("Metric: '",
              method,
              "' using unit: '",
              unit,
              "'; comparing: ",
              ncols,
              " vectors.")
    if (ncols == 2)
      dist <-
        jensen_shannon(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na, unit)
    if (ncols > 2)
      dist <-
        DistMatrix(x, jensen_shannon, test.na, unit)
  }
  
  else if (method == "jensen_difference") {
    if (!mute.message)
      message("Metric: '",
              method,
              "' using unit: '",
              unit,
              "'; comparing: ",
              ncols,
              " vectors.")
    if (ncols == 2)
      dist <-
        jensen_difference(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na, unit)
    if (ncols > 2)
      dist <-
        DistMatrix(x, jensen_difference, test.na, unit)
  }
  
  else if (method == "taneja") {
    if (!mute.message)
      message("Metric: '",
              method,
              "' using unit: '",
              unit,
              "'; comparing: ",
              ncols,
              " vectors.")
    
    if (ncols == 2)
      dist <-
        taneja(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na, unit, epsilon)
    if (ncols > 2)
      dist <- DistMatrix_epsilon(x, taneja, test.na, unit, epsilon)
  }
  
  else if (method == "kumar-johnson") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <-
        kumar_johnson(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na, epsilon)
    if (ncols > 2)
      dist <-
        DistMatrixNoUnit_epsilon(x, kumar_johnson, test.na, epsilon)
  }
  
  else if (method == "avg") {
    if (!mute.message)
      message("Metric: '", method, "'; comparing: ", ncols, " vectors.")
    if (ncols == 2)
      dist <- avg(as.numeric(x[, 1]), as.numeric(x[, 2]), test.na)
    if (ncols > 2)
      dist <- DistMatrixNoUnit(x, avg, test.na)
  }
  
  if (ncols == 2) {
    names(dist) <- method
  } else {
    if (!use.row.names) {
      colnames(dist) <- paste0("v", seq_len(ncols))
      rownames(dist) <-
        paste0("v", seq_len(ncols))
    }
    if (use.row.names) {
      colnames(dist) <- colnames(x)
      rownames(dist) <- colnames(x)
    }
  }
  
  if (!as.dist.obj)
    return(dist)
  
  if (as.dist.obj) {
    if (ncols == 2) {
      dist <- stats::as.dist(matrix(c(0, dist, dist, 0), nrow = 2), diag = diag, upper = upper)
    } else {
      dist <- stats::as.dist(dist, diag = diag, upper = upper)
    }
    attr(dist, "method") <- method
    return(dist)
  }
}
