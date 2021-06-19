# syntax=docker/dockerfile:1

#FROM python:3.6.8
FROM python:3.6-slim

WORKDIR /app

COPY requirements.txt requirements.txt
COPY config.ini config.ini
RUN pip3 install -r requirements.txt

COPY . .

CMD [ "python3", "main.py"]
