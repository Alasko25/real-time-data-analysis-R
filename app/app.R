library(shiny)
library(keras)
library(DT)

# Load pre-trained model
model <- load_model_hdf5("models/keras_model.h5")

# UI
ui <- fluidPage(
  titlePanel("Real-Time Customer Churn Prediction"),
  sidebarLayout(
    sidebarPanel(
      actionButton("start", "Start Real-Time Monitoring"),
      helpText("Live churn classification based on incoming customer data.")
    ),
    mainPanel(
      DTOutput("live_data"),
      plotOutput("churnPlot")
    )
  )
)

# Server
server <- function(input, output, session) {
  values <- reactiveVal(data.frame())

  observeEvent(input$start, {
    invalidateLater(3000, session)
    observe({
      files <- list.files("app/stream_input", full.names = TRUE)
      for (file in files) {
        df <- read.csv(file, stringsAsFactors = TRUE)
        if ("customerID" %in% names(df)) df$customerID <- NULL
        if ("Churn" %in% names(df)) df$Churn <- NULL

        categorical <- sapply(df, is.factor)
        df[categorical] <- lapply(df[categorical], function(x) as.numeric(as.factor(x)))
        X <- scale(df)

        pred <- predict(model, X)
        df$Prediction <- ifelse(pred > 0.5, "Churn", "No Churn")

        values(rbind(values(), df))
        file.remove(file)
      }
    })
  })

  output$live_data <- renderDT({ values() })

  output$churnPlot <- renderPlot({
    req(nrow(values()) > 0)
    barplot(
      table(values()$Prediction),
      col = c("green", "red"),
      main = "Live Churn Predictions",
      ylab = "Count"
    )
  })
}

shinyApp(ui, server)
