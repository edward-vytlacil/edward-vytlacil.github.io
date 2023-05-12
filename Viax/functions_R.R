
# This R script is a supplement to the handout for Lab 1:
# https://edward-vytlacil.github.io/Labs/Lab1/Lab1_Handout_Summer_2022.html
# reviewing user-defined functions 

# if you haven't already installed ggplot
# then uncomment the following line:
# install.packages("ggplot2")


# load library ggplot2


library(ggplot2)


# defining a new function, called f.1,
# which has a single argument x, and then returns the square of that number
# the argument(s) go in the parenthesis after "function",
# while the code to be executed when calling the function goes inside the curly
# brackets.  Consider the function f(x)=1/x
f.1 <- function(x){1/x}

# we can now execute the function
f.1(1)
f.1(2)
f.1(4)

# we can alternatively call the function including the name of the
# argument, though it is unnecessary, e.g.,  f.1(4)=f.1(x=4)
f.1(4)
f.1(x=4)

# we can plot the function
plot.0<- ggplot(data.frame(x = c(0, 1)), aes(x=x))+ 
  stat_function(fun=f.1) 

plot.0

# we could have also plotted the function without defining it ahead of time, 
plot.0b<- ggplot(data.frame(x = c(0, 1)), aes(x=x))+ 
  stat_function(fun=function(x){1/x}) 

plot.0b


# we can have more code to be run inside the curly brackets
# in which case the function returns whatever is on the last line
# for example:
f.2 <- function(x){temp<-c(x,f.1(x)) #note that f.2 takes a scalar as input and returns a vector as output
                  names(temp)<-c("x","1/x") # can also assign names to the vector elements
                  temp}

f.2(1)
f.2(2)
f.2(4)

#
# We could use this function to create a new data frame of (x,1/x) values, for example:
df.1 <- data.frame(rbind(f.2(1),f.2(2),f.2(3),f.2(4),f.2(5)))
# the above code is very cumbersome, and we will later see that with use of the apply function
# that the code can be made far less cumbersome.

# By default, the function will return whatever is on the last line of the code inside the 
# curly brackets, though we could define an explicit return at the last line if desired.
# The following function is exactly the same as f.2
f.3 <- function(x){temp<-c(x,f.1(x))
              names(temp)<-c("x","1/x")
              return(temp)}
f.3(4)

# Thus far, we have considered functions of only one argument.  We could define a
# function that takes multiple arguments.  For example, the following function
# takes as inputs (x,z) and returns z/x

f.4 <- function(x,z){z/x}

f.4(2,1)
f.4(1,2)

# since we defined the function as having (x,z),
# f.4(2,1) is using arguments x=2, z=1, while 
#  f.4(1,2) is using arguments x=1, z=2.   
# we call the function using the names of the arguments
# in which case f.4(2,1)= f.4(x=2,z=1) = f.4(z=1,x=2),
# and f.4(1,2)= f.4(x=1,z=2) = f.4(z=2,x=1)
f.4(2,1)
f.4(x=2,z=1)
f.4(z=1,x=2)

f.4(1,2)
f.4(x=1,z=2)
f.4(z=2,x=1)

# we can plot a function of multiple arugments, but we can only graph over one
# argument at a time (for a 2-dimensional figure).  For example, the following
# code returns an error
# INCORRECT:
plot.wrong <- ggplot(data.frame(x = c(0, 10)), aes(x=x))+ 
  stat_function(fun=f.4) 
plot.wrong

# We can fix this problem by telling R to evaluate the function 
# at specified values for all but one argument of the function,
# using args=list( ) syntax.  For example, the following code
# graphs z/x as a function of  x with z set to equal 1
# (i.e., graphing 1/x):

plot.1 <- ggplot(data.frame(x = c(0, 1)), aes(x=x))+ 
  stat_function(fun=f.4, args=list(z=1))
  
plot.1

# We might be interested in graphing the function as a function
# of x, for alternative values of z.  The following add
# z/x to our figure, for z=5 and z=10 (i.e., graphs 5/x and 10/x)
plot.2 <- plot.1+  stat_function(fun=f.4, args=list(z=5)) +
  stat_function(fun=f.4, args=list(z=10)) 

plot.2

# To make the figure more self-explanatory, we can use a different color
# for each function, and create a length.

plot.3 <- ggplot(data.frame(x = c(0, 1)), aes(x=x))+ 
  stat_function(fun=f.4, args=list(z=1), aes(colour = "y=1/x"))+
  stat_function(fun=f.4, args=list(z=5), aes(colour = "y=5/x"))+
  stat_function(fun=f.4, args=list(z=10), aes(colour = "y=10/x"))

plot.3
