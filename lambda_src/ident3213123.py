import boto3


s3 = boto3.resource("s3")
textract = boto3.client("textract")
s3_source_bucket_name = "tests31tests31"
s3_bucket = s3.Bucket(s3_source_bucket_name)


# getting name from image
def fetch_file_name(s3_bucket):
    for receipt in s3_bucket.objects.all():
        file_name = receipt.key
    return file_name


# pulling data from image

def fetch_data_from_file(file_name):
    file_name = file_name
 
    response = textract.analyze_expense(
        Document={
            'S3Object': {
                'Bucket': s3_source_bucket_name,
                'Name': file_name
            }
        })
        
    print(response)
   

# passing data to dynamodb
# deleting image




####main###

file_name = fetch_file_name(s3_bucket)
fetch_data_from_file(file_name)