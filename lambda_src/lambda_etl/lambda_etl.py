import boto3
import os
from parse_positions import parse_positions_from_file
from parse_invoice_no import parse_invoice_from_file
from put_data_to_db import put_positons_to_dynamodb_pos, delete_file_from_s3

s3 = boto3.resource("s3")
dynamoDB = boto3.resource("dynamodb")
textract = boto3.client("textract")
dynamoTable_pos_name = os.environ["dynamoDB_name"]
s3_source_bucket_name = os.environ["s3_bucket_name"]
dynamoTable_pos = dynamoDB.Table(dynamoTable_pos_name)
s3_bucket = s3.Bucket(s3_source_bucket_name)

class Invoice:
  def __init__(self, id, invoice_number):
    self.id =  id
    self.invoice_number = invoice_number
    self.positions = []

class Position:
  def __init__(self, id, item, quantity, price):
    self.id = id
    self.item = item
    self.quantity = quantity
    self.price = price


def fetch_file_name(s3_bucket):
    for invoice in s3_bucket.objects.all():
        file_name = invoice.key
    return file_name

def fetch_position_data_from_file(file_name):
    file_name = file_name
    file_data = textract.analyze_expense(
        Document={
            'S3Object': {
                'Bucket': s3_source_bucket_name,
                'Name': file_name
            }
        })
    return(file_data)

def fetch_invoice_data_from_file(file_name):
    file_name = file_name
    file_data = textract.detect_document_text(
        Document={
            'S3Object': {
                'Bucket': s3_source_bucket_name,
                'Name': file_name
            }
        })
    return(file_data)


def lambda_handler(event, context):
    #Load positions
    file_position_name = fetch_file_name(s3_bucket)
    file_position_data = fetch_position_data_from_file(file_position_name) 
    positions = parse_positions_from_file(file_position_data)

    #Load invoice
    file_name = fetch_file_name(s3_bucket)
    file_data = fetch_invoice_data_from_file(file_name) 
    invoice = parse_invoice_from_file(file_data)
    invoice.positions = positions
    put_positons_to_dynamodb_pos(invoice)
    delete_file_from_s3(file_name)


 
if __name__ == "__main__": 
    lambda_handler({},{})


