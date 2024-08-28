#!/bin/bash

BASE_DIR="/home/ubuntu/train-ticket-benchmarking"

for dir in "$BASE_DIR"/ts-c*/; do
  echo "Processing CF Update $dir..."

  if [ -f "$dir/template.yml" ]; then
    STACK_NAME=$(basename "$dir")

    # Check if the stack exists
    if aws cloudformation describe-stacks --stack-name "$STACK_NAME" > /dev/null 2>&1; then
      # Update the CloudFormation stack
      aws cloudformation update-stack --stack-name "$STACK_NAME" \
        --template-body file://"$dir/template.yml" \
        --capabilities CAPABILITY_IAM

      echo "Started stack update for $STACK_NAME"
    else
      echo "Stack $STACK_NAME does not exist. Skipping update."
    fi
  else
    echo "Skipping $dir as template.yml is not present."
  fi
done

echo "All ts- microservices with template.yml have been checked for update."
