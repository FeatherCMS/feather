#!/bin/sh
set -eu

READY_FILE=/app/data/.feather-ready
BUCKET="${STORAGE_S3_BUCKET:-feather-cms-app}"
S3_REGION="${STORAGE_S3_REGION:-us-east-1}"
SES_REGION="${SES_REGION:-eu-central-1}"
MEDIA_ALIAS="${MEDIA_CLOUDFRONT_ALIAS:-feather-media.localhost.floci.io}"
FUNCTION_NAME=feather-media-uri-rewrite

rm -f "$READY_FILE"

if ! aws --region "$S3_REGION" s3api head-bucket --bucket "$BUCKET" >/dev/null 2>&1; then
    if [ "$S3_REGION" = "us-east-1" ]; then
        aws --region "$S3_REGION" s3api create-bucket --bucket "$BUCKET" >/dev/null
    else
        aws --region "$S3_REGION" s3api create-bucket \
            --bucket "$BUCKET" \
            --create-bucket-configuration "LocationConstraint=$S3_REGION" >/dev/null
    fi
fi

if aws --region "$SES_REGION" sesv2 get-email-identity \
    --email-identity "${SES_FROM_EMAIL:-no-reply@feather.local}" >/dev/null 2>&1; then
    :
else
    aws --region "$SES_REGION" sesv2 create-email-identity \
        --email-identity "${SES_FROM_EMAIL:-no-reply@feather.local}" >/dev/null
fi

FUNCTION_CONFIG='{"Comment":"Rewrite Feather media URLs to S3 object keys","Runtime":"cloudfront-js-2.0"}'
FUNCTION_CODE=fileb:///opt/feather/cloudfront/media-uri-rewrite.js

if aws cloudfront describe-function \
    --name "$FUNCTION_NAME" \
    --stage DEVELOPMENT >/dev/null 2>&1; then
    FUNCTION_ETAG="$(aws cloudfront describe-function \
        --name "$FUNCTION_NAME" \
        --stage DEVELOPMENT \
        --query ETag \
        --output text)"
    aws cloudfront update-function \
        --name "$FUNCTION_NAME" \
        --if-match "$FUNCTION_ETAG" \
        --function-config "$FUNCTION_CONFIG" \
        --function-code "$FUNCTION_CODE" >/dev/null
else
    aws cloudfront create-function \
        --name "$FUNCTION_NAME" \
        --function-config "$FUNCTION_CONFIG" \
        --function-code "$FUNCTION_CODE" >/dev/null
fi

FUNCTION_ETAG="$(aws cloudfront describe-function \
    --name "$FUNCTION_NAME" \
    --stage DEVELOPMENT \
    --query ETag \
    --output text)"
aws cloudfront publish-function \
    --name "$FUNCTION_NAME" \
    --if-match "$FUNCTION_ETAG" >/dev/null
FUNCTION_ARN="$(aws cloudfront describe-function \
    --name "$FUNCTION_NAME" \
    --stage LIVE \
    --query FunctionSummary.FunctionARN \
    --output text)"

DISTRIBUTION_ID="$(aws cloudfront list-distributions --output json | python3 -c '
import json
import sys

distribution_list = json.load(sys.stdin).get("DistributionList", {})
items = distribution_list.get("Items") or []
print(next((item["Id"] for item in items if item.get("Comment") == "feather-local-media"), ""))
')"

if [ -z "$DISTRIBUTION_ID" ]; then
    cat > /tmp/feather-cloudfront-distribution.json <<EOF
{
  "CallerReference": "feather-local-media",
  "Comment": "feather-local-media",
  "Enabled": true,
  "Aliases": {
    "Quantity": 1,
    "Items": ["$MEDIA_ALIAS"]
  },
  "Origins": {
    "Quantity": 1,
    "Items": [{
      "Id": "feather-s3-origin",
      "DomainName": "$BUCKET.s3.amazonaws.com",
      "S3OriginConfig": {
        "OriginAccessIdentity": ""
      }
    }]
  },
  "DefaultCacheBehavior": {
    "TargetOriginId": "feather-s3-origin",
    "ViewerProtocolPolicy": "allow-all",
    "AllowedMethods": {
      "Quantity": 2,
      "Items": ["GET", "HEAD"],
      "CachedMethods": {
        "Quantity": 2,
        "Items": ["GET", "HEAD"]
      }
    },
    "ForwardedValues": {
      "QueryString": false,
      "Cookies": {"Forward": "none"}
    },
    "MinTTL": 0,
    "FunctionAssociations": {
      "Quantity": 1,
      "Items": [{
        "EventType": "viewer-request",
        "FunctionARN": "$FUNCTION_ARN"
      }]
    }
  }
}
EOF
    DISTRIBUTION_ID="$(aws cloudfront create-distribution \
        --distribution-config file:///tmp/feather-cloudfront-distribution.json \
        --query Distribution.Id \
        --output text)"
else
    aws cloudfront get-distribution-config \
        --id "$DISTRIBUTION_ID" \
        --output json >/tmp/feather-cloudfront-current.json
    DISTRIBUTION_ETAG="$(python3 -c '
import json

with open("/tmp/feather-cloudfront-current.json", encoding="utf-8") as stream:
    print(json.load(stream)["ETag"])
')"
    ALIAS_ADDED="$(python3 - "$MEDIA_ALIAS" <<'PY'
import json
import sys

with open("/tmp/feather-cloudfront-current.json", encoding="utf-8") as stream:
    config = json.load(stream)["DistributionConfig"]

aliases = config.get("Aliases") or {"Quantity": 0, "Items": []}
items = aliases.get("Items") or []
alias_added = sys.argv[1] not in items
if alias_added:
    items.append(sys.argv[1])
aliases["Items"] = items
aliases["Quantity"] = len(items)
config["Aliases"] = aliases

with open("/tmp/feather-cloudfront-distribution.json", "w", encoding="utf-8") as stream:
    json.dump(config, stream)
print("yes" if alias_added else "no")
PY
    )"
    if [ "$ALIAS_ADDED" = "yes" ]; then
        aws cloudfront update-distribution \
            --id "$DISTRIBUTION_ID" \
            --if-match "$DISTRIBUTION_ETAG" \
            --distribution-config file:///tmp/feather-cloudfront-distribution.json >/dev/null
    fi
fi

touch "$READY_FILE"
