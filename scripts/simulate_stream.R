# simulate_stream.R
simulate_stream <- function(input_folder = "data/streaming", delay = 5) {
  files <- list.files(input_folder, full.names = TRUE)
  target_dir <- "app/stream_input"
  dir.create(target_dir, showWarnings = FALSE, recursive = TRUE)

  for (file in files) {
    file.copy(file, file.path(target_dir, basename(file)))
    message("Sent: ", basename(file))
    Sys.sleep(delay)
  }
}