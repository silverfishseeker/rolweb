#!/usr/bin/env bash
set -e

# Cargar variables desde ../.env (formato: KEY: VALUE)
while IFS='=' read -r key value; do
    export "$key=$value"
done < <(
    awk -F': *' '
        /^[[:space:]]*#/ { next }
        /^[[:space:]]*$/ { next }
        {
            key = $1
            sub(/^[[:space:]]+/, "", key)
            sub(/[[:space:]]+$/, "", key)

            value = substr($0, index($0, ":") + 1)
            sub(/^[[:space:]]+/, "", value)
            sub(/[[:space:]]+$/, "", value)

            print key "=" value
        }
    ' ../.env
)

AWS_ACCESS_KEY_ID="$S3_ACCESS_KEY_ID" \
AWS_SECRET_ACCESS_KEY="$S3_SECRET_ACCESS_KEY" \
AWS_DEFAULT_REGION=auto \
aws s3 sync \
    "s3://$S3_BUCKET" \
    ./bucket \
    --endpoint-url "$S3_ENDPOINT"