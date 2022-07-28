FROM python:3.9-slim-buster
WORKDIR /app
ENV AWS_DEFAULT_REGION=eu-central-1
COPY main.py main.py
COPY upload_endpoint.py upload_endpoint.py
COPY show_data.py show_data.py
COPY requirements.txt requirements.txt
COPY /htmldirectory/ /app/htmldirectory
COPY /static        /app/static
RUN pip3 install -r requirements.txt
EXPOSE 80
CMD ["python3", "main.py", "--host=0.0.0.0"]