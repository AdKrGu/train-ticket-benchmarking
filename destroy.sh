#!/bin/bash

BASE_DIR="/home/ubuntu/train-ticket-benchmarking"

for dir in "$BASE_DIR"/ts-*/; do
  echo "Destroying $dir..."

  if [ -f "$dir/main.tf" ]; then

    cd "$dir" || { echo "Failed to navigate to $dir"; exit 1; }

    terraform destroy destroy.tfplan
    
    echo "Completed Destroying $dir"
  else
    echo "Skipping $dir as main.tf is not present."
  fi

  cd "$BASE_DIR" || exit
done
