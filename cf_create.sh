#!/bin/bash

BASE_DIR="/home/ubuntu/train-ticket-benchmarking"

for dir in "$BASE_DIR"/ts-*/; do
  echo "Processing CF Create $dir..."

  if [ -f "$dir/template.yml" ]; then
    STACK_NAME=$(basename "$dir")

    # Deploy the CloudFormation stack
    aws cloudformation create-stack --stack-name "$STACK_NAME" \
      --template-body file://"$dir/template.yml" \
      --capabilities CAPABILITY_IAM

    echo "Started stack creation for $STACK_NAME"
  else
    echo "Skipping $dir as template.yml is not present."
  fi
done

echo "All ts- microservices with template.yml have been initiated for deployment."
