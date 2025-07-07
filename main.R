# Load and analyze
source("scripts/01_load_data.R")
source("scripts/02_exploratory_analysis.R")
source("scripts/03_visualization.R")

# Train model
source("scripts/04_model_training.R")

# Predict
source("scripts/05_prediction_realtime.R")

# Generate report
source("scripts/06_report_generation.R")

# Launch the Shiny app
shiny::runApp("app")
# End of main script