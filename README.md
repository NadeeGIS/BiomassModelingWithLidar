# BiomassModelingWithLidar
This repository contains an R script designed to predict red cedar biomass using LiDAR-derived variables

## The logic

This R script is designed to predict redcedar biomass for the years 2006, 2012, and 2020 using random forest regression.
It loads libraries such as caret, randomForest, raster, GGally, ggplot2, gridExtra, and pdp.

The script loads a dataset (biomass_lidar.csv) containing redcedar biomass, lidar-derived variables, and NDVI (Normalized Difference Vegetation Index). It then performs Pearson correlation analysis on the variables and removes highly correlated ones (> 0.8). The remaining variables are used to build the initial random forest regression model (rf_model1) using 10-fold cross-validation and grid search for tuning parameters.

Next, the script compares variable importance and isolates the best variables for building the final model (rf_model2). The model is refined using the selected variables, and partial dependency plots are generated to visualize the relationship between biomass and these variables.

Finally, the script predicts redcedar biomass for the years 2006, 2012, and 2020 using the final model and writes the results to CSV files (biomass_2006.csv, biomass_2012.csv, biomass_2020.csv).
