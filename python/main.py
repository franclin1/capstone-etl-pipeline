from fastapi import FastAPI, UploadFile, File, Request
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
import uvicorn
from upload_endpoint import upload_image_to_s3
from starlette import status



app = FastAPI()
templates = Jinja2Templates(directory="htmldirectory")



## file upload
@app.post("/upload")
async def root(receipt_image: UploadFile = File(...)):
    upload_image_to_s3(receipt_image)
    return RedirectResponse("/home", status_code=status.HTTP_302_FOUND)

## index website
@app.get("/home", response_class=HTMLResponse)
def write_home(request: Request):
   return templates.TemplateResponse("index.html", {"request": request})
    

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=80)