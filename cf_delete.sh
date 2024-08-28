#!/bin/bash

BASE_DIR="/home/ubuntu/train-ticket-benchmarking"

for dir in "$BASE_DIR"/ts-c*/; do
  echo "Processing CF Delete $dir..."

  if [ -f "$dir/template.yml" ]; then
    STACK_NAME=$(basename "$dir")

    # Check if the stack exists
    if aws cloudformation describe-stacks --stack-name "$STACK_NAME" > /dev/null 2>&1; then
      # Delete the CloudFormation stack
      aws cloudformation delete-stack --stack-name "$STACK_NAME"

      echo "Started stack deletion for $STACK_NAME"
    else
      echo "Stack $STACK_NAME does not exist. Skipping deletion."
    fi
  else
    echo "Skipping $dir as template.yml is not present."
  fi
done

echo "All ts- microservices with template.yml have been checked for deletion."
