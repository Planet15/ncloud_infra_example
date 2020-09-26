#!/usr/bin/env python3
#-*- codig: utf-8 -*-
import os
import urllib.request
import configparser
import argparse
import json
import sys
import time 

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

def loading():
    print ("Converting...")
    for i in range(0, 100):
        time.sleep(0.01)
        sys.stdout.write(u"\u001b[1000D" + str(i + 1) + "%")
        sys.stdout.flush()
    print

if __name__ == '__main__':

    #argparse code  
    parser = argparse.ArgumentParser(description='Converts an input URL into a short URL in the me2.do format.')
    parser.add_argument('targeturl', type=str, help="Original URL")
    args = parser.parse_args()
    targeturl = args.targeturl

    #configparser code
    config = configparser.ConfigParser()
    config.read("./nshorturl.conf")
    client_id = config.get('nshorturl', 'client_id')
    client_secret = config.get('nshorturl', 'client_secret')
    nshorturl = config.get('nshorturl', 'nshorturlgw') 
    
    #check targeturl if not vaild
    try:
        urllib.request.urlopen(targeturl)
    except IOError:
       	print(bcolors.UNDERLINE+"Converts an input URL into a short URL in the me2.do format."+bcolors.ENDC)
        print(bcolors.WARNING+"Not a real URL"+bcolors.ENDC)
       	print(bcolors.FAIL+"Result: Failed"+bcolors.ENDC)
        sys.exit(0)

    #urllib code
    encText = urllib.parse.quote(targeturl)
    data = "url=" + encText
    url = nshorturl 
    request = urllib.request.Request(url)
    request.add_header("X-NCP-APIGW-API-KEY-ID",client_id)
    request.add_header("X-NCP-APIGW-API-KEY",client_secret)

    response = urllib.request.urlopen(request, data=data.encode('utf-8'))
    loading()
    print(" ")
    rescode = response.getcode()

    #result
    if(rescode==200):
        response_body = response.read()
        dict = json.loads(response_body.decode('utf-8'))
       	print(bcolors.UNDERLINE+"Converts an input URL into a short URL in the me2.do format."+bcolors.ENDC)
       	print(bcolors.WARNING+"Shortened URL : "+dict['result']['url']+bcolors.ENDC)
       	print(bcolors.OKBLUE+"Original URL  : "+dict['result']['orgUrl']+bcolors.ENDC)
       	print(bcolors.OKGREEN+"Result: Succeed"+bcolors.ENDC)
    else:
        print(bcolors.FAIL+"Result error code:" + rescode +bcolors.ENDC)
