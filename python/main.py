from fastapi import FastAPI, UploadFile, File, Request
from fastapi.templating import Jinja2Templates
import uvicorn
from upload_endpoint import upload_image_to_s3


app = FastAPI()
templates = Jinja2Templates(directory="app/htmldirectory")


## file upload
@app.post("/submit")
async def root(receipt_image: UploadFile = File(...)):
    upload_image_to_s3(receipt_image)

## index website
@app.get("/home/")
def write_home(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=80)