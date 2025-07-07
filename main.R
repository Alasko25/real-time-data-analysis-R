# This is the main script to run the entire project
source("scripts/simulate_stream.R")
simulate_stream()

shiny::runApp("app")