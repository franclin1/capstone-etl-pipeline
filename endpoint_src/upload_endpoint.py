import boto3
import os 


s3_bucket_name = os.environ["s3_bucket_name"]
s3 = boto3.resource("s3")
s3_bucket = s3.Bucket(s3_bucket_name)

def upload_image_to_s3(file):
    s3_bucket.upload_fileobj(file.file, file.filename)