# CA4 MODULE 3 - ASSIGNMENT 1
# AUTOMOBILE PERFORMANCE PREDICTION

#--------------------------------------------------------------------------------
# QUESTION 1: DATA IMPORT AND EXPLORATION

#Load the dataset
data_url <- "https://raw.githubusercontent.com/plotly/datasets/master/mtcars.csv"
car_data <- read.csv(data_url)

#Print the first 5 rows of the dataset
print(head(car_data))

#Print the last 6 rows of the dataset
print(tail(car_data))

#Print the statistical summary of the dataset
print(summary(car_data))

#Print the dimension of the dataset
print(dim(car_data))

#Print all the column names in the dataset
print(colnames(car_data))

#Print the number of null/missing values in each column 
print(colSums(is.na(car_data)))

#-------------------------------------------------------------------------------------------------
#QUESTION 2 : LINEAR REGRESSION 
#creating a regression model using all 32 cars in our dataset.
#TO PREDICT IF THE MPG(Miles per Gallon-->Fuel efficiency of the vehicle) DEPENDS UPON WEIGHT OF THE VEHICLE.

#Linear Regression Equation: Y=a+bX 
#To create the model we use lm()-->Linear Model function 

#Initializing the linear model by assigning the independent variable and dependent variable and the data to be used 
linear_model <- lm(mpg~wt, data=car_data)

#Displayong the summary of the model created
summary(linear_model)

#Initializing the intercept-->a and the slope-->b
intercept <- coef(linear_model)[1]
slope <- coef(linear_model)[2]

#Printing the Linear Regression Equation
cat("\n Linear Regression Equation")
cat("MPG =",round(intercept,4),"+ ",round(slope,4),"*Weight\n")

#Predicting and displaying the mpg using the created model
predicted_mpg <- predict(linear_model)
head(predicted_mpg)

#------------------------------------------------------------------------------------------------
# QUESTION 3: SCATTER PLOT WITH REGRESSION LINE

# Plotting the scatter plot
plot(car_data$wt, car_data$mpg,
     main = "Vehicle Weight vs Fuel Efficiency",
     xlab = "Vehicle Weight (1000 lbs)",
     ylab = "Miles Per Gallon (MPG)",
     pch = 19,
     col = "blue")

# Adding the regression line
abline(linear_model, col = "red", lwd = 2)

#Here our regression line slopes down from left to right because we have a negative regression i.e -5.3445

#------------------------------------------------------------------------------------------------
#QUESTION 4 : MODEL EVALUVATION
#evaluating how accurately that model predicted MPG.

#Calculating the R-squared
r_squared <- summary(linear_model)$r.squared

#Calculating the R Mean Squared Error
actual_mpg <- car_data$mpg

rmse <- sqrt(mean((actual_mpg - predicted_mpg)^2))

cat("\n Model Evaluvation Results:")
cat("\n R-Squared:",round(r_squared,4))
cat("\n R-Squared Percentage:",round(r_squared*100,2))
cat("\n R-Mean Squared Error:",round(rmse,4))

#Vehicle weight tells there is about 75.28% of the variation in fuel efficiency in this dataset.

#--------------------------------------------------------------------------------------------------
# QUESTION 5: 5-FOLD CROSS-VALIDATION

#Installing the package caret
install.packages("caret")

# Loading the required package
library(caret)

# Setting random seed
set.seed(123)

# Defining 5-fold cross-validation
train_control <- trainControl(method = "cv", number = 5)

# Training the regression model using cross-validation
cv_model <- train(mpg ~ wt,
                  data = car_data,
                  method = "lm",
                  trControl = train_control)

# Displaying cross-validation results
print(cv_model)

# Displaying average RMSE
cat("Average 5-Fold RMSE:",
    round(cv_model$results$RMSE, 4), "\n")

#A model might perform well on one particular train-test split just by chance. 
#Cross-validation gives us a better idea of how consistently it performs on unseen data.

#-------------------------------------------------------------------------------------------------
# QUESTION 6: POLYNOMIAL REGRESSION

# Dividing the dataset into training and testing data
set.seed(123)

train_index <- sample(1:nrow(car_data),
                      size = floor(0.8 * nrow(car_data)))

train_data <- car_data[train_index, ]
test_data <- car_data[-train_index, ]

# Displaying dataset sizes
cat("Total observations:", nrow(car_data), "\n")
cat("Training observations:", nrow(train_data), "\n")
cat("Testing observations:", nrow(test_data), "\n")

# Creating Degree 1 Polynomial Regression Model
model_degree1 <- lm(mpg ~ poly(wt, 1),
                    data = train_data)

# Creating Degree 5 Polynomial Regression Model
model_degree5 <- lm(mpg ~ poly(wt, 5),
                    data = train_data)

# Displaying model summaries
cat("DEGREE 1 MODEL SUMMARY\n")
summary(model_degree1)

cat("\nDEGREE 5 MODEL SUMMARY\n")
summary(model_degree5)

# STEP 3: CALCULATING TRAINING AND TESTING ERRORS

# Predictions using Degree 1 Model
train_pred_1 <- predict(model_degree1, newdata = train_data)
test_pred_1 <- predict(model_degree1, newdata = test_data)

# Predictions using Degree 5 Model
train_pred_5 <- predict(model_degree5, newdata = train_data)
test_pred_5 <- predict(model_degree5, newdata = test_data)

# Calculating RMSE for Degree 1
train_rmse_1 <- sqrt(mean((train_data$mpg - train_pred_1)^2))
test_rmse_1 <- sqrt(mean((test_data$mpg - test_pred_1)^2))

# Calculating RMSE for Degree 5
train_rmse_5 <- sqrt(mean((train_data$mpg - train_pred_5)^2))
test_rmse_5 <- sqrt(mean((test_data$mpg - test_pred_5)^2))

# Displaying results
cat("MODEL COMPARISON RESULTS\n")

cat("\nDegree 1 Model:\n")
cat("Training RMSE:", round(train_rmse_1, 4), "\n")
cat("Testing RMSE:", round(test_rmse_1, 4), "\n")

cat("\nDegree 5 Model:\n") 
cat("Training RMSE:", round(train_rmse_5, 4), "\n")
cat("Testing RMSE:", round(test_rmse_5, 4), "\n") 
