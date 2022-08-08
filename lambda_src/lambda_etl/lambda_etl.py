import boto3
import os
import uuid
import re


s3 = boto3.resource("s3")
dynamoDB = boto3.resource("dynamodb")
textract = boto3.client("textract")
dynamoTable_pos_name = os.environ["dynamoDB_name"]
s3_source_bucket_name = os.environ["s3_bucket_name"]
dynamoTable_pos = dynamoDB.Table(dynamoTable_pos_name)
s3_bucket = s3.Bucket(s3_source_bucket_name)

ITEM_NAME_INDEX = 1
ITEM_QUANTITY_INDEX = 2
ITEM_VAT_INDEX = 3
ITEM_PRICE_INDEX = 4
ITEM_DICT = "ValueDetection"
ITEM_KEY = "Text"

class Invoice:
  def __init__(self, id, invoice_number):
    self.id =  id
    self.invoice_number = invoice_number
    self.positions = []

class Position:
  def __init__(self, id, item, quantity, vat, price):
    self.id = id
    self.item = item
    self.quantity = quantity
    self.vat = vat
    self.price = price


def fetch_file_name(s3_bucket):
    file_name=""
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

def list_contains_items(position, positions):
    if position in positions:
            return True 
    return False

def parse_positions_from_file(file_data):
    receipt = file_data
    expensedocuments = receipt["ExpenseDocuments"]
    positions = []
    for category in expensedocuments:
        if not "LineItemGroups" in category:
            continue
        LineItemGroups = category["LineItemGroups"]
        for LineItemGroup in LineItemGroups:
            LineItems = LineItemGroup["LineItems"]
            for LineItem in LineItems:
                LineItemExpenseFields = LineItem["LineItemExpenseFields"]
                id = str(uuid.uuid4())
                item_name = LineItemExpenseFields[ITEM_NAME_INDEX][ITEM_DICT][ITEM_KEY]
                item_quantity = LineItemExpenseFields[ITEM_QUANTITY_INDEX][ITEM_DICT][ITEM_KEY]
                item_vat = LineItemExpenseFields[ITEM_VAT_INDEX][ITEM_DICT][ITEM_KEY]
                item_price = LineItemExpenseFields[ITEM_PRICE_INDEX][ITEM_DICT][ITEM_KEY]
                position = Position(id, item_name, item_quantity, item_vat, item_price)
                if list_contains_items(position, positions):
                    continue
                positions.append(position)
    return positions

def parse_invoice_from_file(file_data):
    invoice = file_data
    invoice_number = ""
    matchwords = ["Rechnung Nr.", "Rechnungsnummer", "Rechnungsnummer:"]
    blocks = invoice["Blocks"]
    for block in blocks:
        if not "LINE" in block["BlockType"]:
            continue
        block_text = block["Text"]
        for matchword in matchwords:
            if (block_text.find(matchword) != -1):
                search = re.search(r"\d",  block_text)
                index = search.start()
                while index > 0:
                    if block_text[index] == " ":
                        invoice_number = block_text[index+1:]
                        break
                    index = index - 1
    id = str(uuid.uuid4())
    return Invoice(id, invoice_number)

def put_positions_to_dynamodb_pos(invoice):
        for position in invoice.positions:
            response = dynamoTable_pos.put_item(
            Item={   
                    "Id" : position.id,
                    "Invoice_No" : invoice.invoice_number,
                    "Item": position.item,
                    "Price": position.price,
                    "Vat": position.vat,
                    "Quantity": position.quantity,
                }
            )
        return response

def delete_file_from_s3(file_name):
    s3.Object(s3_source_bucket_name, file_name).delete()



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
    put_positions_to_dynamodb_pos(invoice)
    delete_file_from_s3(file_name)


 
if __name__ == "__main__": 
    lambda_handler({},{})


