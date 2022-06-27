blockpi节点监控部署

> 所需软件：[Zabbix](https://www.zabbix.com/)

2、脚本说明：该脚本监控了节点的分数score和状态active

脚本所在位置：/etc/zabbix/scripts/get_test_info.py

```python
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
```

3、配置监控项

```shell
$ cat /etc/zabbix/zabbix_agentd.d/userparameter_blockpi.conf
# klaytn节点进程
UserParameter=klaytn.status,ps aux|egrep 'klaytn'|grep -v grep|wc -l
# blockpi节点进程
UserParameter=blockpi.process,ps aux|egrep 'HyperNode'|grep -v grep|wc -l
# blockpi operator节点状态
UserParameter=blockpi.status,python3 /etc/zabbix/scripts/get_test_info.py status
# blockpi节点分数
UserParameter=blockpi.score,python3 /etc/zabbix/scripts/get_test_info.py score
```

配置完记得重启agent服务

```shell
sudo systemctl restart zabbix-agent.service
```

4、在zabbix web网页上创建上述监控项即可