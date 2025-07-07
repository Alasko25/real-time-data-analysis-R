library(shiny)
library(keras)
library(DT)

model <- load_model_hdf5("models/keras_model.h5")

ui <- fluidPage(
  titlePanel("Live Customer Feedback Classification"),
  mainPanel(
    actionButton("start", "Start Real-Time Analysis"),
    DTOutput("live_data"),
    plotOutput("fraudPlot")
  )
)

server <- function(input, output, session) {
  values <- reactiveVal(data.frame())

  observeEvent(input$start, {
    invalidateLater(3000, session)  # réexécute tous les 3s
    observe({
      files <- list.files("app/stream_input", full.names = TRUE)
      for (file in files) {
        df <- read.csv(file)
        pred <- predict(model, as.matrix(df))
        df$Prediction <- ifelse(pred > 0.5, "Positive", "Negative")
        values(rbind(values(), df))
        file.remove(file)
      }
    })
  })

  output$live_data <- renderDT({ values() })
  output$fraudPlot <- renderPlot({
    barplot(table(values()$Prediction), col = c("green", "red"))
  })
}

shinyApp(ui, server)
