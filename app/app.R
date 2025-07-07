library(shiny)
library(keras)
library(DT)

# Charger le modèle
model <- load_model_hdf5("models/fraud_model.h5")

# Interface
ui <- fluidPage(
  titlePanel("Fraud Detection Dashboard"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload CSV"),
      actionButton("predict", "Predict")
    ),
    mainPanel(
      DTOutput("table"),
      plotOutput("fraudPlot")
    )
  )
)

# Serveur
server <- function(input, output) {
  data <- reactiveVal()

  observeEvent(input$predict, {
    req(input$file)
    df <- read.csv(input$file$datapath)
    pred <- predict(model, as.matrix(df[, c("amount", "customer_age")]))
    df$predicted_fraud <- ifelse(pred > 0.5, "Yes", "No")
    data(df)
  })

  output$table <- renderDT({
    req(data())
    datatable(data())
  })

  output$fraudPlot <- renderPlot({
    req(data())
    barplot(table(data()$predicted_fraud), col = c("green", "red"), main = "Fraud Predictions")
  })
}

shinyApp(ui, server)
