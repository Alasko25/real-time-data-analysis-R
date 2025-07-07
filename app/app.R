library(shiny)
library(keras)
library(DT)
library(ggplot2)
library(DataExplorer)
library(gganimate)
library(gapminder)
library(gifski)
library(rmarkdown)

data <- read.csv("../data/data.csv", stringsAsFactors = TRUE)

if ("customerID" %in% colnames(data)) data$customerID <- NULL
if ("Churn" %in% colnames(data)) data$Churn <- ifelse(data$Churn == "Yes", 1, 0)
cat_cols <- sapply(data, is.factor)
data[cat_cols] <- lapply(data[cat_cols], function(x) as.numeric(as.factor(x)))

model_path <- "app/models/keras_model.h5"
model <- NULL
if (file.exists(model_path)) {
  model <- load_model_hdf5(model_path)
}

ui <- fluidPage(
  titlePanel("📊 Real-Time Customer Churn Analysis Dashboard"),

  sidebarLayout(
    sidebarPanel(
      actionButton("train", "🔁 Train Model"),
      actionButton("start", "▶ Start Real-Time Monitoring"),
      actionButton("stop", "⏸ Stop Monitoring"),
      actionButton("report", "📄 Generate PDF Report"),
      br(), br(),
      helpText("Visualize churn data, training progress, and real-time predictions.")
    ),

    mainPanel(
      tabsetPanel(id = "tabs",
        tabPanel("📁 Data Preview", DTOutput("data_table")),
        tabPanel("📊 Data Visualization", plotOutput("scatterPlot")),
        tabPanel("📉 Model Training Loss", imageOutput("lossPlot")),
        tabPanel("🔎 Real-Time Predictions", 
                 DTOutput("live_data"),
                 plotOutput("churnPlot"))
      )
    )
  )
)

server <- function(input, output, session) {
  values <- reactiveValues(
    df = data,
    predictions = data.frame(),
    history = NULL,
    monitoring = FALSE
  )

  output$data_table <- renderDT({ datatable(values$df) })

  output$scatterPlot <- renderPlot({
    ggplot(values$df, aes(x = tenure, y = MonthlyCharges, color = as.factor(Churn))) +
      geom_point(alpha = 0.5) +
      theme_minimal() +
      labs(color = "Churn")
  })

  observeEvent(input$train, {
    X <- scale(values$df[, !colnames(values$df) %in% c("Churn")])
    Y <- values$df$Churn

    model <<- keras_model_sequential() %>%
      layer_dense(units = 64, activation = "relu", input_shape = ncol(X)) %>%
      layer_dense(units = 32, activation = "relu") %>%
      layer_dense(units = 1, activation = "sigmoid")

    model %>% compile(
      loss = "binary_crossentropy",
      optimizer = "adam",
      metrics = c("accuracy")
    )

    history <- model %>% fit(
      X, Y, epochs = 20, batch_size = 32, validation_split = 0.2
    )

    save_model_hdf5(model, filepath = model_path)
    values$history <- history

    updateTabsetPanel(session, "tabs", selected = "📉 Model Training Loss")

    # Save animated plot for ggplot2
    loss_df <- data.frame(
      epoch = 1:length(history$metrics$loss),
      loss = history$metrics$loss
    )

    p <- ggplot(loss_df, aes(x = epoch, y = loss)) +
      geom_line(color = "blue") +
      geom_point(color = "darkblue") +
      labs(title = "Loss Curve", y = "Loss") +
      transition_reveal(epoch)

    anim_save("../outputs/plots/loss_animation.gif", animate(p, renderer = gifski_renderer(), width = 600, height = 400))
  })

  output$lossPlot <- renderImage({
    list(src = "../outputs/plots/loss_animation.gif", contentType = "image/gif", width = "100%")
  }, deleteFile = FALSE)

  observeEvent(input$start, {
    values$monitoring <- TRUE
    updateTabsetPanel(session, "tabs", selected = "🔎 Real-Time Predictions")
  })

  observeEvent(input$stop, {
    values$monitoring <- FALSE
  })

  observe({
    invalidateLater(3000, session)
    if (isTRUE(values$monitoring) && !is.null(model)) {
      files <- list.files("app/stream_input", full.names = TRUE)
      if (length(files) == 0) return()

      for (file in files) {
        df <- read.csv(file, stringsAsFactors = TRUE)
        if ("customerID" %in% names(df)) df$customerID <- NULL
        if ("Churn" %in% names(df)) df$Churn <- NULL

        cat_cols <- sapply(df, is.factor)
        df[cat_cols] <- lapply(df[cat_cols], function(x) as.numeric(as.factor(x)))
        df_scaled <- scale(df)

        pred <- predict(model, df_scaled)
        df$Prediction <- ifelse(pred > 0.5, "Churn", "No Churn")

        values$predictions <- rbind(values$predictions, df)
        file.remove(file)
      }
    }
  })

  output$live_data <- renderDT({
    req(nrow(values$predictions) > 0)
    datatable(values$predictions)
  })

  output$churnPlot <- renderPlot({
    req(nrow(values$predictions) > 0)
    barplot(
      table(values$predictions$Prediction),
      col = c("green", "red"),
      main = "Live Churn Predictions",
      ylab = "Count"
    )
  })

  observeEvent(input$report, {
  showModal(modalDialog("⏳ Generating PDF report... Please wait...", footer = NULL))

  # 1. Auto report from DataExplorer
  try({
    DataExplorer::create_report(
      data = values$df,
      output_format = "pdf_document",
      output_file = "report.pdf",
      output_dir = "../outputs/reports"
    )
  }, silent = TRUE)

  # 2. Custom scatter plot (PDF)
  try({
    p2 <- ggplot(values$df, aes(x = tenure, y = MonthlyCharges, color = as.factor(Churn))) +
      geom_point(alpha = 0.5) +
      theme_minimal() +
      labs(color = "Churn", title = "Customer Distribution: Tenure vs Monthly Charges")
    
    ggsave("../outputs/reports/customer_scatterplot.pdf", plot = p2, width = 7, height = 5)
  }, silent = TRUE)
  
  # 3. Training loss and accuracy (PDF)
  try({
    if (!is.null(values$history)) {
      loss_df <- data.frame(
        epoch = seq_along(values$history$metrics$loss),
        Loss = values$history$metrics$loss,
        Accuracy = values$history$metrics$accuracy
      )
      
      p <- ggplot(loss_df, aes(x = epoch)) +
        geom_line(aes(y = Loss, color = "Loss")) +
        geom_line(aes(y = Accuracy, color = "Accuracy")) +
        labs(title = "Model Training Metrics", y = "Value", x = "Epoch") +
        scale_color_manual(values = c("Loss" = "blue", "Accuracy" = "green")) +
        theme_minimal()
      
      ggsave("../outputs/reports/model_training_metrics.pdf", plot = p, width = 7, height = 5)
    }
  }, silent = TRUE)

  removeModal()
  showModal(modalDialog("✅ All reports and plots generated in 'outputs/reports/'", easyClose = TRUE))
})


}

shinyApp(ui, server)
