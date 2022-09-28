#! /bin/bash
#-----------------------------

#解析JSON
function getJsonValuesByAwk() {
    awk -v json="$1" -v key="$2" -v defaultValue="$3" 'BEGIN{
        foundKeyCount = 0
        while (length(json) > 0) {
            # pos = index(json, "\""key"\""); ## 这行更快一些，但是如果有value是字符串，且刚好与要查找的key相同，会被误认为是key而导致值获取错误
            pos = match(json, "\""key"\"[ \\t]*?:[ \\t]*");
            if (pos == 0) {if (foundKeyCount == 0) {print defaultValue;} exit 0;}

            ++foundKeyCount;
            start = 0; stop = 0; layer = 0;
            for (i = pos + length(key) + 1; i <= length(json); ++i) {
                lastChar = substr(json, i - 1, 1)
                currChar = substr(json, i, 1)

                if (start <= 0) {
                    if (lastChar == ":") {
                        start = currChar == " " ? i + 1: i;
                        if (currChar == "{" || currChar == "[") {
                            layer = 1;
                        }
                    }
                } else {
                    if (currChar == "{" || currChar == "[") {
                        ++layer;
                    }
                    if (currChar == "}" || currChar == "]") {
                        --layer;
                    }
                    if ((currChar == "," || currChar == "}" || currChar == "]") && layer <= 0) {
                        stop = currChar == "," ? i : i + 1 + layer;
                        break;
                    }
                }
            }

            if (start <= 0 || stop <= 0 || start > length(json) || stop > length(json) || start >= stop) {
                if (foundKeyCount == 0) {print defaultValue;} exit 0;
            } else {
                print substr(json, start, stop - start);
            }

            json = substr(json, stop + 1, length(json) - stop)
        }
    }'
}

#HTTP RPC接口请求  method klay_blockNumber 自己的节点请求到的块信息
json1=$(curl -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"klay_blockNumber","params":[],"id":1}' http://134.119.192.13:8551)
#解析json中的result字段 获取16进制的块信息
RESULT1=getJsonValuesByAwk "$json1" "result" "defaultValue"

#HTTP RPC接口请求  method klay_blockNumber 公共的节点请求到的块信息
json=$(curl -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"klay_blockNumber","params":[],"id":1}' https://klaytn02.fandom.finance)
#解析json中的result字段 获取16进制的块信息
RESULT=getJsonValuesByAwk "$json" "result" "defaultValue"

if [ RESULT1 < RESULT ]
then
  #说明节点掉块，邮件发送异常通知
  echo false
else
  #说明正常
  echo true
fi  

