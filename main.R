# This is the main script to run the entire project
source("scripts/01_load_data.R")
source("scripts/02_exploratory_analysis.R")
source("scripts/03_visualization.R")
source("scripts/04_model_training.R")
source("scripts/05_prediction_realtime.R")
source("scripts/06_report_generation.R")
shiny::runApp("app")