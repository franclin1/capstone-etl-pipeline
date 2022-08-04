import uuid
import re
from  lambda_etl import Invoice

def parse_invoice_from_file(file_data):
    invoice = file_data
    invoice_number = ""
    matchwords = ["Rechnung Nr.", "Rechnungsnummer", "Rechnungsnummer:"]
    blocks = invoice["Blocks"]
    for block in blocks:
        if "LINE" in block["BlockType"]:
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