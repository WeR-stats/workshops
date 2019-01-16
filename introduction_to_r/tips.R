## Example of how R is sometimes strict about data types and won't cast the objects
# diff requires a vector or a matrix. it won't work with a dataframe even if its elements are numeric
x <- data.frame(c1 = 1:10, c2 = 11:20)
str(x)  # x is a dataframe of integers
diff(x) # this gives an error
x <- data.frame(c1 = as.numeric(1:10), c2 = as.numeric(11:20)) # you see the error and think that the problem is with the contnent being integer...
str(x)  # x is now a dataframe of numerics but ...
diff(x) # also this gives an error
x <- as.matrix(x) # or x <- matrix(1:20, ncol = 2, dimnames = list(NULL, c('c1', 'c2')))
str(x)  # x is now a matrix
diff(x) # and the function works!

# ==> even if from the point oif view of the user the "content" of two objects are the same, internally they are completely different
#     not every function is capable to convert automatically

