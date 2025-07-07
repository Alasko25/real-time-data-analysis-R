# 03_Visualization.R
library(ggplot2)

# Example: tenure vs MonthlyCharges by Churn
ggplot(data, aes(x = tenure, y = MonthlyCharges, color = as.factor(Churn))) +
  geom_point(alpha = 0.5) +
  theme_minimal() +
  labs(color = "Churn")

library(plotly)
plot_ly(data, x = ~tenure, y = ~MonthlyCharges, color = ~as.factor(Churn), type = "scatter", mode = "markers")