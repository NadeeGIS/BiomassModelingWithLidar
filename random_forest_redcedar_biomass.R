# use random forest to predict redcedar biomass 2006, 2012, 2020

# load libraries
library(caret)
library(randomForest)
library(GGally)
library(ggplot2)
library(gridExtra)
library(pdp)

setwd("/Users/13193/OneDrive - The University of South Dakota/Desktop/chapter1/redcedar_biomass/")
list.files()

# load data with redcedar biomass, lidar derived variables and NDVI
data1 <- read.csv("biomass_lidar.csv")
# head(data1)

# perform-pearson correlation
corr <-cor(data1)
corrplot(corr, type="upper", order="hclust",
         col=brewer.pal(n=16, name="RdYlBu"))

# remove highly correlated variables > 0.8
data2<-data1[c("biomass","ndvi","d1_15", "d10_15","gt15","gt10", "d0_1","std", "h10", "mean","skew", "cv")]
# head(data2)


# Define the control for 10-fold cross-validation
trControl <- trainControl(
  method = "cv",
  number = 10,
  search = "grid"
)

tuneGrid <- expand.grid(mtry = c(2, 3, 4, 5, 6))

# Run the model with random forest regression and grid search
rf_model1 <- train(
  biomass ~ .,
  data = data2,
  method = "rf",
  ntree= 500,
  trControl = trControl,
  tuneGrid=tuneGrid
)

plot(rf_model1)

# Print the results
print(rf_model1)

# Display variable importance
varImp(rf_model1)

##########################################################################################################
# compare variable importance and isolate the best variables

data3<-data2[c("biomass","ndvi","d1_15", "d10_15")]


# Define the control for 10-fold cross-validation
trControl <- trainControl(
  method = "cv",
  number = 10,
  search = "grid"
)

tuneGrid <- expand.grid(mtry = c(2, 3, 4))

# Run the model with random forest regression and grid search to develop final model
rf_model2 <- train(
  biomass ~ .,
  data = data3,
  method = "rf",
  ntree= 500,
  trControl = trControl,
  tuneGrid=tuneGrid
)
plot(rf_model2)

# Print the results
print(rf_model2)

# partial dependency plots to see relationship between biomass and final best variables
grid.arrange(
  partial(rf_model2, pred.var = "ndvi", plot = TRUE, rug = TRUE),
  partial(rf_model2, pred.var = "d1_15", plot = TRUE, rug = TRUE),
  partial(rf_model2, pred.var = "d10_15", plot = TRUE, rug = TRUE),
  ncol = 2 
)

# calculate redcedar biomass for 2020
lidar_2020 <- read.csv("/Users/13193/OneDrive - The University of South Dakota/Desktop/chapter1/redcedar_biomass/to_predict2020.csv")
biomass_2020 <- predict(rf_model2, )
biomass_2020 <- cbind(lidar_2020, biomass_2020)
write.csv(biomass_2020, "/Users/13193/OneDrive - The University of South Dakota/Desktop/chapter1/redcedar_biomass/biomass_2020.csv")

# calculate redcedar biomass for 2012
lidar_2012 <- read.csv("/Users/13193/OneDrive - The University of South Dakota/Desktop/chapter1/redcedar_biomass/to_predict2012.csv")
biomass_2012 <- predict(rf_model2 , lidar_2012)
biomass_2012 <- cbind(lidar_2012, biomass_2012)
write.csv(biomass_2012, "/Users/13193/OneDrive - The University of South Dakota/Desktop/chapter1/redcedar_biomass/biomass_2012.csv")

# calculate redcedar biomass for 2006
lidar_2006 <- read.csv("/Users/13193/OneDrive - The University of South Dakota/Desktop/chapter1/redcedar_biomass/to_predict2006.csv")
biomass_2006 <- predict(rf_model2 , lidar_2006)
biomass_2006 <- cbind(lidar_2006, biomass_2006)  
write.csv(biomass_2006, "/Users/13193/OneDrive - The University of South Dakota/Desktop/chapter1/redcedar_biomass/biomass_2006.csv")
