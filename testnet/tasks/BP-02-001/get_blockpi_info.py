#!/usr/bin/python3
# -*- coding: utf-8 -*-
import requests
import json
import sys
import  socket

operation = sys.argv[1]
hostname = socket.gethostname()

url1 = "http://testnet.explorer.blockpi.io/v1/rpc"
params = json.dumps({"method":"explorer_hypernode","params":[{"nodeId":"0x09384a8fe58a9298677453330698c5c7fa8d1819"}],"id":1,"jsonrpc":"2.0"})
# 通用http首部
headers = {"Content-Type": "application/json"}

data1 = json.loads((requests.post(url1,params,headers=headers)).text)

if operation == 'score':
    # node score
    print(data1["result"]["score"])
elif operation == 'status':
    # node status
    stat = str(data1["result"]["status"])
    if stat == "active":
        print(1)
    else:
        print(0)
