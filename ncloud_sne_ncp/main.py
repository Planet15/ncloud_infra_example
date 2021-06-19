from flask import Flask  # 서버 구현을 위한 Flask 객체 import
from flask_restx import Api, Resource  # Api 구현을 위한 Api 객체 import
from flask import request
import time
import requests
import hmac
import socket
import configparser
import base64
import hashlib
import json


app = Flask(__name__)  # Flask 객체 선언, 파라미터로 어플리케이션 패키지의 이름을 넣어줌.
api = Api(app)  # Flask 객체에 Api 객체 등록

config = configparser.ConfigParser()
config.read('config.ini')

server_ip = config['server']['server_ip']
server_port = config['server']['server_port']
sms_url = config['sms']['sms_url']
sms_access_key = config['sms']['sms_access_key']
sms_secret_key = config['sms']['sms_secret_key']
sms_uri = config['sms']['sms_uri']
sms_type = config['sms']['sms_type']
sms_from_countryCode = config['sms']['sms_from_countryCode']
sms_from_number = config['sms']['sms_from_number']
sms_to_number = config['sms']['sms_to_number']

@api.route('/webhook')  # 데코레이터 이용, '/hello' 경로에 클래스 등록
class HelloWorld(Resource):

    # send sms message
    def make_signature(access_key, secret_key, method, uri, timestmap):
        timestamp = str(int(time.time() * 1000))
        secret_key = bytes(secret_key, 'UTF-8')

        message = method + " " + uri + "\n" + timestamp + "\n" + access_key
        message = bytes(message, 'UTF-8')
        signingKey = base64.b64encode(hmac.new(secret_key, message, digestmod=hashlib.sha256).digest())
        return signingKey

    def send_sms(phone_number, subject, message):
        #  URL
        url = sms_url 
        # access key
        access_key = sms_access_key 
        # secret key
        secret_key = sms_secret_key
        # uri
        uri = sms_uri
        timestamp = str(int(time.time() * 1000))

        body = {
           "type":sms_type,
           "contentType":"COMM",
           "countryCode":sms_from_countryCode,
           "from":sms_from_number,
           "content": message,
           "messages":[
              {
                  "to": phone_number,
                  "subject": subject,
                  "content": message
              }
            ]
           }

        key = HelloWorld.make_signature(access_key, secret_key, 'POST', uri, timestamp)
        headers = {
          'Content-Type': 'application/json; charset=utf-8',
          'x-ncp-apigw-timestamp': timestamp,
          'x-ncp-iam-access-key': access_key,
          'x-ncp-apigw-signature-v2': key
        }   


        res = requests.post(url, json=body, headers=headers)
        print(res.json())
        return res.json()

    def get(self):  # GET 요청시 리턴 값에 해당 하는 dict를 JSON 형태로 반환
        HelloWorld.send_sms(sms_to_number, 'test', 'test..test')
    
    def post(self):  # POST 요청시 리턴 값에 해당 하는 dict를 JSON 형태로 반환
        params = json.loads(request.get_data(), encoding='utf-8')
        if len(params) == 0:
          return 'No parameter'

        params_str = ''
        for key in params.keys():
          params_str += ' {}:{} '.format(key, params[key])

        return HelloWorld.send_sms(sms_to_number, 'Alert_message', params_str)

if __name__ == "__main__":
    app.run(debug=True, host=server_ip, port=server_port)
