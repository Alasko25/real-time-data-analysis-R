# Exploratory Data Analysis
library(DataExplorer)
summary(data)
cor(data)
plot_correlation(data)
plot_boxplot(data, by = "Churn")