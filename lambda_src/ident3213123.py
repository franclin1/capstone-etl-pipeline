import boto3

s3 = boto3.resource("s3")

#s3_request_file_name = "1.jpg"
s3_source_bucket_name = "tests31tests31"

s3_bucket = s3.Bucket(s3_source_bucket_name)

# getting name from image
def fetch_file_name(s3_bucket):
    for receipt in s3_bucket.objects.all():
        print(receipt.key)

# pulling data from image
# passing data to dynamodb
# deleting image




####main###
fetch_file_name(s3_source_bucket_name)