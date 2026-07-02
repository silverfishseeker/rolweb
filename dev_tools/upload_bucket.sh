#!/usr/bin/env bash
set -e

read -rp "S3 Endpoint: " S3_ENDPOINT
read -rp "Bucket: " S3_BUCKET
read -rp "Access Key ID: " S3_ACCESS_KEY_ID
read -rsp "Secret Access Key: " S3_SECRET_ACCESS_KEY
echo

AWS_ACCESS_KEY_ID="$S3_ACCESS_KEY_ID" \
AWS_SECRET_ACCESS_KEY="$S3_SECRET_ACCESS_KEY" \
AWS_DEFAULT_REGION=auto \
aws s3 sync \
    ./bucket \
    "s3://$S3_BUCKET" \
    --endpoint-url "$S3_ENDPOINT"