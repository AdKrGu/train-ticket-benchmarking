#!/bin/bash

BASE_DIR="/home/ubuntu/train-ticket"

for dir in "$BASE_DIR"/ts-*/; do
  echo "Planning Destroy $dir..."

  if [ -f "$dir/main.tf" ]; then

    cd "$dir" || { echo "Failed to navigate to $dir"; exit 1; }

   terraform plan -destroy -out=destroy.tfplan
    
    echo "Completed Planning Destroy $dir"
  else
    echo "Skipping $dir as main.tf is not present."
  fi

  cd "$BASE_DIR" || exit
done
