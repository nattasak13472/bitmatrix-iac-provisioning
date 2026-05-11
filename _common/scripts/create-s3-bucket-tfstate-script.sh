#!/bin/bash

# ==========================================================
# Target Bucket Configuration
# ==========================================================
# Available options:
# bitmatrix-crypto-dealer-nonprod-th-tfstate (Region: ap-southeast-7)
# bitmatrix-crypto-dealer-prod-th-tfstate    (Region: ap-southeast-7)
# bitmatrix-crypto-dealer-prod-sg-tfstate    (Region: ap-southeast-1)

S3_BUCKET_NAME="bitmatrix-crypto-dealer-nonprod-th-tfstate"
S3_BUCKET_REGION="ap-southeast-7"

echo "=========================================================="
echo "Processing Bucket: $S3_BUCKET_NAME in Region: $S3_BUCKET_REGION"
echo "=========================================================="

# 1. Create S3 Bucket
echo "-> Creating bucket..."
if [ "$S3_BUCKET_REGION" == "us-east-1" ]; then
    # us-east-1 does not require LocationConstraint
    aws s3api create-bucket \
      --bucket "$S3_BUCKET_NAME" \
      --region "$S3_BUCKET_REGION"
else
    aws s3api create-bucket \
      --bucket "$S3_BUCKET_NAME" \
      --region "$S3_BUCKET_REGION" \
      --create-bucket-configuration LocationConstraint="$S3_BUCKET_REGION"
fi

# 2. Enable S3 Bucket Versioning
echo "-> Enabling versioning..."
aws s3api put-bucket-versioning \
  --bucket "$S3_BUCKET_NAME" \
  --versioning-configuration Status=Enabled

# 3. Block Public Access
echo "-> Blocking public access..."
aws s3api put-public-access-block \
  --bucket "$S3_BUCKET_NAME" \
  --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
  
echo "Done with $S3_BUCKET_NAME."
echo ""
