# Read the package list
packages <- readLines("requirements.txt")

# Remove comments and empty lines
packages <- trimws(packages)
packages <- packages[packages != "" & !grepl("^#", packages)]

# Install missing packages only
for (pkg in packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  } else {
    message(pkg, " is already installed.")
  }
}

# install keras and tensorflow if not already installed
library(keras)
install_keras()  # This installs TensorFlow backend in Python via reticulate
