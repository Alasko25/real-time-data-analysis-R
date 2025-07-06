library(ggplot2)

ggplot(data, aes(x = var1, y = var2, color = category)) +
  geom_point() +
  theme_minimal()

library(plotly)
plot_ly(data, x = ~var1, y = ~var2, type = "scatter", mode = "markers")
