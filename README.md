philentropy
===========

[![Travis-CI Build Status](https://travis-ci.org/HajkD/philentropy.svg?branch=master)](https://travis-ci.org/HajkD/philentropy) [![rpackages.io rank](https://www.rpackages.io/badge/philentropy.svg)](https://www.rpackages.io/package/philentropy) [![status](http://joss.theoj.org/papers/cad5ffc246ce197b06ccad1af7d2932a/status.svg)](http://joss.theoj.org/papers/cad5ffc246ce197b06ccad1af7d2932a)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/philentropy)](https://github.com/metacran/cranlogs.app)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/grand-total/philentropy)](https://github.com/metacran/cranlogs.app)


### Similarity and Distance Quantification between Probability Functions

> Describe and understand the world through data.

Data collection and data comparison are the foundations of scientific research.
_Mathematics_ provides the abstract framework to describe patterns we observe in nature and _Statistics_ provides the
framework to quantify the uncertainty of these patterns. In statistics, natural patterns
are described in form of probability distributions which either follow a fixed pattern (parametric distributions) or more dynamic patterns (non-parametric distributions).

The `philentropy` package implements fundamental distance and similarity measures to quantify distances between probability density functions as well as traditional information theory measures. In this regard, it aims to provide a framework for comparing
natural patterns in a statistical notation.  

This project is born out of my passion for statistics and I hope that it will be useful to
the people who share it with me.

### Installation
```r
# install philentropy version 0.2.0 from CRAN
install.packages("philentropy")
```

### Citation

> HG Drost, (2018). __Philentropy: Information Theory and Distance Quantification with R__. _Journal of Open Source Software_, 3(26), 765. https://doi.org/10.21105/joss.00765

## Tutorials 

 - [Introduction to the philentropy package](https://hajkd.github.io/philentropy/articles/Introduction.html)
 - [Distance and Similarity Measures implemented in philentropy](https://hajkd.github.io/philentropy/articles/Distances.html)
 - [Information Theory Metrics implemented in philentropy](https://hajkd.github.io/philentropy/articles/Information_Theory.html)

## Examples

```r
library(philentropy)
# retrieve available distance metrics
getDistMethods()
```

```
 [1] "euclidean"         "manhattan"         "minkowski"        
 [4] "chebyshev"         "sorensen"          "gower"            
 [7] "soergel"           "kulczynski_d"      "canberra"         
[10] "lorentzian"        "intersection"      "non-intersection" 
[13] "wavehedges"        "czekanowski"       "motyka"           
[16] "kulczynski_s"      "tanimoto"          "ruzicka"          
[19] "inner_product"     "harmonic_mean"     "cosine"           
[22] "hassebrook"        "jaccard"           "dice"             
[25] "fidelity"          "bhattacharyya"     "hellinger"        
[28] "matusita"          "squared_chord"     "squared_euclidean"
[31] "pearson"           "neyman"            "squared_chi"      
[34] "prob_symm"         "divergence"        "clark"            
[37] "additive_symm"     "kullback-leibler"  "jeffreys"         
[40] "k_divergence"      "topsoe"            "jensen-shannon"   
[43] "jensen_difference" "taneja"            "kumar-johnson"    
[46] "avg"
```

```r
# define a probability density function P
P <- 1:10/sum(1:10)
# define a probability density function Q
Q <- 20:29/sum(20:29)

# combine P and Q as matrix object
x <- rbind(P,Q)

# compute the jensen-shannon distance between
# probability density functions P and Q
distance(x, method = "jensen-shannon")
```

```
jensen-shannon using unit 'log'.
jensen-shannon 
    0.02628933
```

Alternatively, users can also retrieve values from all available distance/similarity metrics
using `dist.diversity()`:


```r
dist.diversity(x, p = 2, unit = "log2")
```

```
        euclidean         manhattan 
       0.12807130        0.35250464 
        minkowski         chebyshev 
       0.12807130        0.06345083 
         sorensen             gower 
       0.17625232        0.03525046 
          soergel      kulczynski_d 
       0.29968454        0.42792793 
         canberra        lorentzian 
       2.09927095        0.49712136 
     intersection  non-intersection 
       0.82374768        0.17625232 
       wavehedges       czekanowski 
       3.16657887        0.17625232 
           motyka      kulczynski_s 
       0.58812616        2.33684211 
         tanimoto           ruzicka 
       0.29968454        0.70031546 
    inner_product     harmonic_mean 
       0.10612245        0.94948528 
           cosine        hassebrook 
       0.93427641        0.86613103 
          jaccard              dice 
       0.13386897        0.07173611 
         fidelity     bhattacharyya 
       0.97312397        0.03930448 
        hellinger          matusita 
       0.32787819        0.23184489 
    squared_chord squared_euclidean 
       0.05375205        0.01640226 
          pearson            neyman 
       0.16814418        0.36742465 
      squared_chi         prob_symm 
       0.10102943        0.20205886 
       divergence             clark 
       1.49843905        0.86557468 
    additive_symm  kullback-leibler 
       0.53556883        0.13926288 
         jeffreys      k_divergence 
       0.31761069        0.04216273 
           topsoe    jensen-shannon 
       0.07585498        0.03792749 
jensen_difference            taneja 
       0.03792749        0.04147518 
    kumar-johnson               avg 
       0.62779644        0.20797774
```
 
### Install Developer Version
```r
# install.packages("devtools")
# install the current version of philentropy on your system
library(devtools)
install_github("HajkD/philentropy", build_vignettes = TRUE, dependencies = TRUE)
```

### NEWS

The current status of the package as well as a detailed history of the functionality of each version of `philentropy` can be found in the [NEWS](https://hajkd.github.io/philentropy/news/index.html) section.

## Important Functions

### Distance Measures
* `distance()` : Implements 46 fundamental probability distance (or similarity) measures
* `getDistMethods()` : Get available method names for 'distance'
* `dist.diversity()` : Distance Diversity between Probability Density Functions
* `estimate.probability()` : Estimate Probability Vectors From Count Vectors

### Information Theory

* `H()` : Shannon's Entropy H(X)
* `JE()` : Joint-Entropy H(X,Y)
* `CE()` : Conditional-Entropy H(X | Y)
* `MI()` : Shannon's Mutual Information I(X,Y)
* `KL()` : Kullback–Leibler Divergence
* `JSD()` : Jensen-Shannon Divergence
* `gJSD()` : Generalized Jensen-Shannon Divergence


## Discussions and Bug Reports

I would be very happy to learn more about potential improvements of the concepts and functions
provided in this package.

Furthermore, in case you find some bugs or need additional (more flexible) functionality of parts
of this package, please let me know:

https://github.com/HajkD/philentropy/issues

or find me on [twitter: HajkDrost](https://twitter.com/hajkdrost) 



