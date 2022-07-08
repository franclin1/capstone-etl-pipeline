from fastapi import FastAPI, UploadFile, File
import boto3
import uvicorn
from upload_endpoint import upload_image_to_s3

app = FastAPI()


@app.post("/upload")
async def root(file: UploadFile):
    upload_image_to_s3(file)
    return file.filename


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=80)