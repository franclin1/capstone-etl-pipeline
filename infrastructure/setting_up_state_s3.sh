#Name of the state bucket
TERRAFORM_S3_BUCKET_NAME=capstone-bucket-malte-cgn-tf-state
if aws s3 ls "s3://$TERRAFORM_S3_BUCKET_NAME" 2>&1 | grep -q 'An error occurred'
then
    aws s3api create-bucket --bucket $TERRAFORM_S3_BUCKET_NAME --region eu-central-1 --create-bucket-configuration LocationConstraint=eu-central-1
else
    echo "Terraform bucket to store state file exists allready"
fi