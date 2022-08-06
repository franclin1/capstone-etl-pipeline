from lambda_etl import Position
import uuid

ITEM_NAME_INDEX = 1
ITEM_QUANTITY_INDEX = 2 
ITEM_PRICE_INDEX = 4
ITEM_DICT = "ValueDetection"
ITEM_KEY = "Text"



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
                item_name = LineItemExpenseFields[ITEM_NAME_INDEX][ITEM_DICT][ITEM_KEY]
                item_quantity = LineItemExpenseFields[ITEM_QUANTITY_INDEX][ITEM_DICT][ITEM_KEY]
                item_price = LineItemExpenseFields[ITEM_PRICE_INDEX][ITEM_DICT][ITEM_KEY]
                id = str(uuid.uuid4())
                position = Position(id, item_name, item_quantity, item_price)
                if list_contains_items(position, positions):
                    continue
                positions.append(position)
    return positions