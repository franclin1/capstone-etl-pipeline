from fileinput import filename
import boto3

s3 = boto3.resource("s3")
dynamoDB = boto3.resource("dynamodb")
textract = boto3.client("textract")
dynamoTable = dynamoDB.Table("invoice-data")
s3_source_bucket_name = "tests31tests31"
s3_bucket = s3.Bucket(s3_source_bucket_name)



def fetch_file_name(s3_bucket):
    for receipt in s3_bucket.objects.all():
        file_name = receipt.key
    return file_name

def fetch_data_from_file(file_name):
    file_name = file_name
    file_data = textract.analyze_expense(
        Document={
            'S3Object': {
                'Bucket': s3_source_bucket_name,
                'Name': file_name
            }
        })
    return(file_data)

def list_contains_items(item_name, items_list):
    for item in items_list:
        if item["Item"] == item_name:
            return True 
    return False

def parse_data_from_file(file_data):
    receipt = file_data
    expensedocuments = receipt["ExpenseDocuments"]
    items_list = []
    for category in expensedocuments:
        if "LineItemGroups" in category:
            LineItemGroups = category["LineItemGroups"]
            for LineItem in LineItemGroups:
                LineItems = LineItem["LineItems"]
                for LineItemExpenseField in LineItems:
                    LineItemExpenseFields = LineItemExpenseField["LineItemExpenseFields"]
                    item_name = LineItemExpenseFields[1]["ValueDetection"]["Text"]
                    item_quantity = LineItemExpenseFields[2]["ValueDetection"]["Text"]
                    item_unit_type = LineItemExpenseFields[3]["ValueDetection"]["Text"]
                    item_price = LineItemExpenseFields[4]["ValueDetection"]["Text"]
                    item_price_total = LineItemExpenseFields[5]["ValueDetection"]["Text"]
                    
                    if list_contains_items(item_name, items_list):
                        continue
                    if LineItemExpenseFields[2]["Type"]["Text"] == "QUANTITY":
                        items_list.append({
                            "Item" : item_name,
                            "Price" : item_price,
                            "Quantity": item_quantity,
                            "Unit" : item_unit_type,
                            "Total" : item_price_total
                        })
                    else:
                        items_list.append({
                            "Item" : item_name,
                            "Price" : item_price,
                            "Quantity": "1",
                            "Unit" : item_unit_type,
                            "Total" : item_price_total 
                        })
    return items_list

def put_data_to_dynamodb(items_list, file_name):

    for item in items_list:
    
        items_list_db = items_list 
        response = dynamoTable.put_item(
        Item={

                'Item': item["Item"],
                'Price': item["Price"],
                'Quantity': item["Quantity"],
                'Unit': item["Unit"],
                'Item': item["Item"],
                "Total": item["Total"]
                
            }
        )
        s3.Object(s3_source_bucket_name, file_name).delete()
    return response


def handle(event, context):
    file_name = fetch_file_name(s3_bucket)
    file_data = fetch_data_from_file(file_name) 
    items_list = parse_data_from_file(file_data)
    put_data_to_dynamodb(items_list, file_name)


 
if __name__ == "__main__": 
    handle({},{})