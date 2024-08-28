#!/bin/bash

BASE_DIR="/home/ubuntu/train-ticket-benchmarking"

# Function to apply Terraform configuration for a given directory
apply_terraform() {
  local dir=$1
  echo "Applying $dir..."
  cd "$dir" || { echo "Failed to navigate to $dir"; exit 1; }
  terraform apply -auto-approve
  echo "Completed Applying $dir"
}

# Iterate over each directory inside the base directory with prefix "ts-"
for dir in "$BASE_DIR"/ts-*/; do
  if [ -f "$dir/main.tf" ]; then
    apply_terraform "$dir" &
  else
    echo "Skipping $dir as main.tf is not present."
  fi
done

# Wait for all background jobs to finish
wait

echo "All terraform apply operations are complete."
