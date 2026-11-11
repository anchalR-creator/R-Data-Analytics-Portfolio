
# ASSIGNMENT 2
# CLASSIFICATION AND DIMENSIONALITY REDUCTION

# QUESTION 1: LOAD DATASET AND DISPLAY SUMMARY

data_url <- "https://raw.githubusercontent.com/mwaskom/seaborn-data/master/iris.csv"

flower_data <- read.csv(data_url)

head(flower_data)

str(flower_data)

summary(flower_data)

dim(flower_data)

table(flower_data$species)

#---------------------------------------------------------------------------------------------
# QUESTION 2: KNN CLASSIFICATION

# Install and load KNN package
install.packages("class")
library(class)

# Select two numerical features
flower_features <- flower_data[, c("petal_length", "petal_width")]

# Select flower species
flower_labels <- as.factor(flower_data$species)

# Display selected features
head(flower_features)

# Display species labels
head(flower_labels)

#--------------------------------------------------------------------------------------------
# Split data into training and testing

set.seed(123)

train_index <- sample(1:nrow(flower_data), 120)

train_data <- flower_features[train_index, ]

test_data <- flower_features[-train_index, ]

train_labels <- flower_labels[train_index]

test_labels <- flower_labels[-train_index]

# Display dataset sizes

nrow(train_data)

nrow(test_data)

# Standardise training and testing data

train_scaled <- scale(train_data)

test_scaled <- scale(
  test_data,
  center = attr(train_scaled, "scaled:center"),
  scale = attr(train_scaled, "scaled:scale")
)

# Apply KNN algorithm

knn_prediction <- knn(
  train = train_scaled,
  test = test_scaled,
  cl = train_labels,
  k = 5
)

# Display predicted species

print(knn_prediction)
#--------------------------------------------------------------------------------------------
# QUESTION 3: CLASSIFICATION ACCURACY

# Compare actual and predicted species
confusion_matrix <- table(
  Actual = test_labels,
  Predicted = knn_prediction
)

print(confusion_matrix)

# Calculate classification accuracy
correct_predictions <- sum(diag(confusion_matrix))

total_predictions <- sum(confusion_matrix)

accuracy <- correct_predictions / total_predictions

print(accuracy)

# Display accuracy in percentage
print(accuracy * 100)

#--------------------------------------------------------------------------------------------
# QUESTION 4: PRINCIPAL COMPONENT ANALYSIS

# Select numerical features

numerical_data <- flower_data[, 1:4]

# Display the selected data

head(numerical_data)

# Apply PCA

pca_result <- prcomp(numerical_data, scale. = TRUE)

# Display PCA results

print(pca_result)

# Display PCA summary

summary(pca_result)

#--------------------------------------------------------------------------------------------
# QUESTION 5: FACTOR ANALYSIS

# Perform factor analysis

factor_result <- factanal(
  numerical_data,
  factors = 1
)

# Display factor analysis results

print(factor_result)

#--------------------------------------------------------------------------------------------
# QUESTION 6: ORIGINAL FEATURES VS REDUCED FEATURES

# Extract the first two principal components

reduced_data <- predict(pca_result)[, 1:2]

# Display original features

head(numerical_data)

# Display reduced features

head(reduced_data)

# Compare dimensions

dim(numerical_data)

dim(reduced_data) 

# Compare original and reduced features

barplot(
  c(ncol(numerical_data), ncol(reduced_data)),
  names.arg = c("Original Features", "PCA Features"),
  main = "Original vs Reduced Features",
  ylab = "Number of Features",
  col = c("skyblue", "lightgreen")
)

#--------------------------------------------------------------------------------------------
