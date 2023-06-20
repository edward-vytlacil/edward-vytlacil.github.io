# P0.R
# R-script for PS0 for GEC
## Installing R handout:   https://edward-vytlacil.github.io/GEC/Install_R.pdf
## Problem set 0: https://edward-vytlacil.github.io/GEC/PS0_summer_2023.pdf
## Review Lecture Slides: https://edward-vytlacil.github.io/GEC/Review_Lecture.pdf
## Handout rules for expected value, variance: https://edward-vytlacil.github.io/GEC/Handout_Review_Rules_Exp_Var_Summer_2023.pdf

library(ggplot2, quietly = TRUE) # need to install package if not already installed

 
#  Asset Diversification
#
## Suppose Pr[r_F=.2]=.5,Pr[r_F=-.1]=.5.   
## what is E[r_F]?
er_F   <- (.5 * .2) - (.5*.1)
er_F
## what is Var(r_F)?  Remember that the variance is a measure of risk.
var_F  <- (.5 * (.2-er_F)^2) + (.5 * (-.1-er_F)^2)
var_F


## Suppose Pr[r_T=.6]=.5,Pr[r_T=-.4]=.5.   
## what is E[r_T]?
er_T   <- (.5*.6) - (.5*.4)
er_T
## what is Var(r_T)?  Remember that the variance is a measure of risk.
var_T  <- (.5 * (.6-er_T)^2) + (.5 * (-.4-er_T)^2)
var_T 

## Suppose:
## Pr[r_F=.2,r_T=.6]=0.05
## Pr[r_F=.2,r_T=-.4]=0.45
## Pr[r_F=-.1,r_T=.6]=0.45
## Pr[r_F=-.1,r_T=-.4]=0.05
## What is Cov(r_F,r_T)?
cov_FT <- (.05 * (0.2-er_F)* (.6-er_T))+
  (.45 * (0.2-er_F)* (-.4-er_T)) +
  (.45 * (-0.1-er_F)*(.6-er_T)) + 
  (.05 * (-0.1-er_F)*(-.4-er_T))
cov_FT

## What is Corr(r_F,r_T)?
corr_FT <- cov_FT/(sqrt(var_T) * sqrt(var_F))
corr_FT
 
# consider portfolio that invests half in ford, half in tesla
# what is expected return on portfolio?  
er_P <- .5 * er_F + .5 *er_T
er_P
# what is variance of return on portfolio?  
var_P <- (.5)^2 * var_F +
  (.5)^2 * var_T +
  2* (.5)^2 *  cov_FT
var_P
 
# Creating a plot to show expected return/risk tradeoff 
# between holding only ford, only Tesla, or the portfolio that
# invests half in each.

# Create a vector of names
Company <- c("Ford", "Tesla","Portfolio")

# Create a vector of expected returns
Er      <- c(er_F,er_T,er_P)

# Create a vector of variances
Var     <- c(var_F,var_T,var_P)

# Create a data frame that combines the above three vectors
df <- data.frame(Company,Er,Var)

# Use ggplot to plot the required graph.
ggplot(df, aes(x = Var, y = Er, color = Company)) +
  geom_point(size = 5) +
  theme_bw() + ggtitle("Risk-Return Tradeoff") +
  xlab("Variance") + ylab("Expected Returns")

# now creating a figure to show expected return-risk tradeoff
# for all possible portfolios investing fraction wF in 
# ford and fraction 1-wF in tesla.

# Create a data frame containing all possible weights
weights <- seq(from = 0, to = 1, length.out = 1000)
tab <- data.frame(wF = weights, wT = 1 - weights)

# Create a variable with the expected returns of each portfolio
tab$er_p  <-  tab$wF * er_F + tab$wT * er_T

# Create a variable with the variance of each portfolio
tab$var_p <-  tab$wF^2 * var_F + 
  tab$wT^2 * var_T +
  2 * tab$wF * (1 - tab$wF) * cov_FT

# Use ggplot to plot the required graph.
ggplot(data = tab, aes(x = var_p, y = er_p, color = wF)) +
  geom_point() +
  theme_bw()  +
  ggtitle("Risk-Return Trade-off") +
  xlab("Volatility") +
  ylab("Expected Returns")

#In Finance, the risk-return trade-off basically states that, in order to get a higher return, you must assume some risk. The right side of the last graph clearly illustrates this trade-off by showing that you reduce your expected return by moving away from Tesla shares in the direction of
# holding a more diversified and safer portfolio.
# However, the last graph also illustrates the power of diversification very clearly. Since the two assets are negative correlated, it is better to hold a porfolio than hold only Ford's shares because a portfolio can provide a higher expected return keeping the risk level constant.


