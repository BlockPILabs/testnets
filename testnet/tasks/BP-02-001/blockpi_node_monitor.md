### blockpi节点监控部署

> 所需软件：[Zabbix](https://www.zabbix.com/)

#### 1、脚本

说明：该脚本监控了节点的分数score和状态active

所在位置：[/etc/zabbix/scripts/get_blockpi_info.py](https://github.com/Terminet-Labs/testnets/blob/main/testnet/tasks/BP-02-001/get_blockpi_info.py)

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
# nodeId参数自行修改
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

#### 2、配置监控项

```shell
$ vim /etc/zabbix/zabbix_agentd.d/userparameter_blockpi.conf
# klaytn节点进程
UserParameter=klaytn.status,ps aux|egrep 'klaytn'|grep -v grep|wc -l
# blockpi节点进程
UserParameter=blockpi.process,ps aux|egrep 'HyperNode'|grep -v grep|wc -l
# blockpi operator节点状态
UserParameter=blockpi.status,python3 /etc/zabbix/scripts/get_blockpi_info.py status
# blockpi节点分数
UserParameter=blockpi.score,python3 /etc/zabbix/scripts/get_blockpi_info.py score
```

配置完记得重启agent服务

```shell
sudo systemctl restart zabbix-agent.service
```

#### 3、在zabbix web网页上创建上述监控项
1）创建模板，创建上述监控项
![zabbix001_img](https://github.com/Terminet-Labs/testnets/blob/main/testnet/tasks/BP-02-001/img/zabbix001.png)
2）选择blockpi节点服务器添加上述模板，可查看监控获取到的数据
![zabbix002_img](https://github.com/Terminet-Labs/testnets/blob/main/testnet/tasks/BP-02-001/img/zabbix002.png)
