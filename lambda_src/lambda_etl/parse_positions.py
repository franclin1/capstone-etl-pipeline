from lambda_etl import Position
import uuid

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
        for LineItem in LineItemGroups:
            LineItems = LineItem["LineItems"]
            for LineItemExpenseField in LineItems:
                LineItemExpenseFields = LineItemExpenseField["LineItemExpenseFields"]
                item_name = LineItemExpenseFields[1]["ValueDetection"]["Text"]
                item_quantity = LineItemExpenseFields[2]["ValueDetection"]["Text"]
                item_price = LineItemExpenseFields[4]["ValueDetection"]["Text"]
                id =  id = str(uuid.uuid4())

                position = Position(id, item_name, item_quantity, item_price)
                if list_contains_items(position, positions):
                    continue
                positions.append(position)
    return positions