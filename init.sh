#!/bin/bash

BASE_DIR="/home/ubuntu/train-ticket-benchmarking"

# Function to initialize Terraform for a given directory
init_terraform() {
  local dir=$1
  echo "Init $dir..."
  cd "$dir" || { echo "Failed to navigate to $dir"; exit 1; }
  terraform init -input=false
  echo "Completed Init $dir"
}

# Iterate over each directory inside the base directory with prefix "ts-"
for dir in "$BASE_DIR"/ts-*/; do
  if [ -f "$dir/main.tf" ]; then
    init_terraform "$dir" &
  else
    echo "Skipping $dir as main.tf is not present."
  fi
done

# Wait for all background jobs to finish
wait

echo "All terraform init operations are complete."
