import boto3

bucket_name = "image-dump-s3-cgn-capstone"
search_terms_list = ["Rechnung", "Invoice"]

ident_image = "Blumenheller_schwer.png"

def check_for_search_terms():

    client = boto3.client("rekognition")
    response = client.detect_text(Image={'S3Object': {'Bucket': bucket_name,'Name': ident_image}})
    textdetections  = response["TextDetections"]

    for line in textdetections:
        search_term = line["DetectedText"]
        for x in search_terms_list:
            if x in search_term:
                return True
    return False
        
def delete_object_non_receipt(state):
    client = boto3.client("s3")
    if state != True:
        client.delete_object(Bucket=bucket_name, Key=ident_image)



check_for_search_terms()
state = check_for_search_terms()
#delete_object_non_receipt(state)