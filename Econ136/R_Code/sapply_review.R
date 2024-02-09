
# This R script reviewing sapply function 
# it is intended as a supplement to Problem Set 2
# It builds upon
# what you learned  about functions in R from functions_R.R
# which you can download from
# https://edward-vytlacil.github.io/Misc/functions_R.R
# You will use sapply extensively in your Problem Set 2.

# defining a new function, called f.1,
f.1 <- function(x){1/x}

# we can now execute the function
f.1(1)
f.1(10)
f.1(100)

# We can use sapply to execute the function at 
# a vector of evaluation points.  The following line of code 
# returns the same output as the above lines of code.

sapply(c(1,10,100),f.1)

# Notice that the vector of evaluation points comes first inside the 
# the parantheses, followed by the name of the function.  There
# isn't much need for sapply when evaluating at 3 evaluation points,
# but is highly useful when evaluating at many evaluation points. For example:
sapply(1:100,f.1)

# for functions defined on one line, we don't need to define the function ahead of time, 
sapply(1:100,function(x){1/x})


# what if we use sapply for functions that take multiple arguments?
# the following function takes as inputs (x,z) and returns z/x

f.4 <- function(x,z){z/x}

# consider evaluating the function at x=2 and z=1,2,5 or 10
f.4(2,1)
f.4(2,2)
f.4(2,5)
f.4(2,10)

# the following code returns the same output as the
# four lines above
sapply(c(1,2,5,10),f.4,x=2)

# consider evaluating the function at z=2 and x=1,2,5 or 10
f.4(1,2)
f.4(2,2)
f.4(5,2)
f.4(10,2)

# the following code returns the same output as the
# four lines above
sapply(c(1,2,5,10),f.4,z=2)


# we often use sapply with data frames, to apply functions 
# to each individual variable of the data frame.  We will now
# load some financial returns data to use as an example.
# the data set is in STATA format, so we have to use
# a package to read in the STATA data.  Here, I am using 
# the function `read_dta` from the package `haven`.  see, e.g.,
# https://www.marsja.se/how-to-read-and-write-stata-dta-files-in-r-with-haven/

# if you don't already have haven installed, then uncomment 
# the following line:
# install.packages("haven")

# load the library `haven`
library(haven)

# I have the data online at https://edward-vytlacil.github.io/Data/financeR.dta 
# now read that data into a data frame using function `read_dta` from package `haven`
df <- read_dta("https://edward-vytlacil.github.io/Data/financeR.dta")

# the read_dta returns a tibble instead of a standard data fame
# and we aren't covering tibbles
# so I'm going to convert it to be a standard data frame
df <- as.data.frame(df)

# class(df)  returns the class of the object df, which is a data frame,
# not the class of the individual variables in the data frame.
class(df)

# to get the class of the individual variables in the data frame,
# we could proceed one variable at a time
names(df)
class(df$date)
class(df$r_M)
# and so forth , or,more succinctly
# we could use sapply:
sapply(df,class)
# notice how class(df) is a data frame, while sapply(df,class) returns the class
# of each variable in the data frame.

# we will want to do certain operations on numeric variables, for example, we
# will want to calculate the sample mean and sample variance only of numeric variables.
# Consider checking which variables are numeric
is.numeric(df$date)
is.numeric(df$r_M)
# and so forth, or more convenient:
sapply(df,is.numeric)

# Suppose we wanted to calculate the mean of each variable in the data frame,
# and save the results in a vector.  (e.g., you will do this in your second problem set)
# The following does not work:
mean(df)
# We could calcualte the mean one variable at a time
mean(df$r_M) 
mean(df$r_A) 
# and so forth, or more convenient:
sapply(df,mean)
# though the above gives us a warning message, because the
# first variable in the df is date which is a character string.
# to take the mean of all but first variable (recall first variable is a character string)
sapply(df[,-1],mean)
# same as above, choosing all columns that are numeric (i.e., all but first variable)
sapply(df[,sapply(df,is.numeric)],mean)
# To save the results as a vector, we would simply write
means.df <- sapply(df[,sapply(df,is.numeric)],mean)
means.df 

# we can do var of df, which returns the variance-covariance matrix
# of the random variables.  We will cover var-cov matices later in 
# the course
var(df)
# the above returns NAs and a warning message since date is
# a character variable.  To do the same  but only over numeric variables:
var(df[,sapply(df,is.numeric)])

# if we don't want the var-cov matrix, but just the variance of each
# variable, we would do the following:
sapply(df,var)
# better, only over the numeric variables.
sapply(df[,sapply(df,is.numeric)],var)
# again we could save the results, for example, if we wanted to 
# use the variances in a plot as you will do for your second problem set.
var.df <-  sapply(df[,sapply(df,is.numeric)],var)
var.df
