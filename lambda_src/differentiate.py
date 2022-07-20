import boto3

bucket_name = "BUCKETNAME"
search_terms_list = ["K-U-N-D-E-N-B-E-L-E-G", "KUNDENBELEG", "KASSENBELEG", "KASSENBON"]

ident_image = "2.jpg"

def check_for_search_terms():

    client = boto3.client("rekognition")
    response = client.detect_text(Image={'S3Object': {'Bucket': bucket_name,'Name': ident_image}})
    textdetections  = response["TextDetections"]
    for image in textdetections:
        for searchterm in search_terms_list:
            if searchterm in image["DetectedText"]:
                print("RECEIPT IDENTIFIED")
                return True
    return False
        
def delete_object_non_receipt(state):
    client = boto3.client("s3")
    if state != True:
        client.delete_object(Bucket=bucket_name, Key=ident_image)


check_for_search_terms()
state = check_for_search_terms()
delete_object_non_receipt(state)