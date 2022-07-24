from datetime import datetime
import boto3
import re

s3 = boto3.resource("s3")
dynamoDB = boto3.resource("dynamodb")
textract = boto3.client("textract")
dynamoTable_pos = dynamoDB.Table("Positions")
dynamoTable_invoice = dynamoDB.Table("Invoices")
s3_source_bucket_name = "image-dump-s3-cgn-capstone"
s3_bucket = s3.Bucket(s3_source_bucket_name)

class Invoice:
  def __init__(self, id, invoice_number):
    self.id = id
    self.invoice_number = invoice_number
    self.positions = []


class Position:
  def __init__(self, item, quantity, price):
    self.item = item
    self.quantity = quantity
    self.price = price


def fetch_file_name(s3_bucket):
    for receipt in s3_bucket.objects.all():
        file_name = receipt.key
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
        if "LineItemGroups" in category:
            LineItemGroups = category["LineItemGroups"]
            for LineItem in LineItemGroups:
                LineItems = LineItem["LineItems"]
                for LineItemExpenseField in LineItems:
                    LineItemExpenseFields = LineItemExpenseField["LineItemExpenseFields"]
                    item_name = LineItemExpenseFields[1]["ValueDetection"]["Text"]
                    item_quantity = LineItemExpenseFields[2]["ValueDetection"]["Text"]
                    item_price = LineItemExpenseFields[4]["ValueDetection"]["Text"]
                    
                    position = Position(item_name, item_quantity, item_price)
                    if list_contains_items(position, positions):
                        continue
                    positions.append(position)
    return positions

def parse_invoice_from_file(file_data):
    invoice = file_data
    blocks = invoice["Blocks"]
    for block in blocks:
        if "LINE" in block["BlockType"]:
            block_text = block["Text"]
            if (block_text.find("Rechnung Nr.") != -1):
                search = re.search(r"\d",  block_text)
                index = search.start()
                while index > 0:
                    if block_text[index] == " ":
                        invoice_nr = block_text[index+1:-1]
                        break
                    index = index - 1
    id = str(datetime.now())
    return Invoice(id, invoice_nr)

def put_positons_to_dynamodb_pos(invoice):     
        for position in invoice.positions:
            response = dynamoTable_pos.put_item(
            Item={   
                    "Id" : invoice.invoice_number,
                    'Item': position.item,
                    'Price': position.price,
                    'Quantity': position.quantity,
                }
            )
        return response

def put_invoice_no_to_dynamodb_invoice(invoice):     
        response = dynamoTable_invoice.put_item(
        Item={   
                "Id" : invoice.id,
                'Invoice No.': invoice.invoice_number
            }
        )
        return response

def delete_file_from_s3(file_name):
    s3.Object(s3_source_bucket_name, file_name).delete()

def handle(event, context):
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
    put_invoice_no_to_dynamodb_invoice(invoice)
    #delete_file_from_s3(file_name)


 
if __name__ == "__main__": 
    handle({},{})


