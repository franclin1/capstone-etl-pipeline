import boto3
import os 

dynamoDB_table_name = os.environ["dynamoDB_name"]
dynamoDB = boto3.resource('dynamodb')
dynamoDB_table = dynamoDB.Table(dynamoDB_table_name)

def get_data():
    response = dynamoDB_table.scan()
    invoice_items = response["Items"]
    items_list = []
    for item in invoice_items:
        items_list.append(item)
    return items_list

def map_data(items_list):
    item=[]
    for element in items_list:
        item_tuple = (element["Item"],element["Price"],element["Vat"],element["Quantity"],element["Invoice_No"])
        item.append(item_tuple)
    return item

def present_data():
    items_list = get_data()
    return map_data(items_list)
   
