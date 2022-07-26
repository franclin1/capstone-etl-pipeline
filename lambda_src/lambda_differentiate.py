import boto3
import os 


lambda_client = boto3.client("lambda")
bucket_name = os.environ["s3_bucket_name"]
lambda_etl_arn = os.environ["etl_function_arn"]
search_terms_list = ["Rechnung", "Invoice"]


def extract_file_name(event):
    for record in event["Records"]:
        image_data = record["s3"]["object"]
        data_keys = image_data.values()
        data_keys = list(data_keys)
        file_name= data_keys[0]
    return file_name
    

def check_for_search_terms(file_name):
    client = boto3.client("rekognition")
    response = client.detect_text(Image={'S3Object': {'Bucket': bucket_name,'Name': file_name}})
    textdetections  = response["TextDetections"]
    for line in textdetections:
        text_to_check = line["DetectedText"]
        for searchterm in search_terms_list:
            if searchterm in text_to_check:
                return True
    return False
    
        
def delete_object_non_receipt(state, file_name):
    client = boto3.client("s3", region_name="eu-central-1")
    if state != True:
        client.delete_object(Bucket=bucket_name, Key=file_name)
    return False


def invoke_etl_lambda():
        lambda_client.invoke(
        FunctionName = lambda_etl_arn,
        InvocationType = "Event"
    )



def lambda_handler(event, context):
    file_name=extract_file_name(event)
    check_for_search_terms(file_name)
    state = check_for_search_terms(file_name)
    delete_object_non_receipt(state, file_name)
    invoke_etl_lambda()


if __name__ == "__main__": 
    lambda_handler({},{})
