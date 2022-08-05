from lambda_etl import dynamoTable_pos, s3, s3_source_bucket_name

def put_positions_to_dynamodb_pos(invoice):
        for position in invoice.positions:
            response = dynamoTable_pos.put_item(
            Item={   
                    "Id" : position.id,
                    "Invoice_No" : invoice.invoice_number,
                    'Item': position.item,
                    'Price': position.price,
                    'Quantity': position.quantity,
                }
            )
        return response


def delete_file_from_s3(file_name):
    s3.Object(s3_source_bucket_name, file_name).delete()
