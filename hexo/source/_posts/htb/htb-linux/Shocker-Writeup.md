---
title: Shocker
date: 2020-11-10 05:34:53
category: Hack The Box
---

# Shocker Writeup

![](./1.png)

## 0x00 写在前面

## 0x01 信息收集
就给一个 IP，不扫端口你还能咋地，`nmap` 走起来。
### 1、TCP Scan
``` java
nmap -A -p- -oA nmap/tcp 10.10.10.56
```
发现两个开放端口。
- **80**: apache 2.4.18，可能是漏洞版本，开放了 web 页面，title 无
- **2222**: OpenSSH 7.2p2，操作系统为 ubuntu linux

![](./2.png)
### 2、UDP Scan
``` java
nmap -sU -A -p- -oA nmap/udp 10.10.10.56
```
无结果。

**总结：只开放了 tcp 两个端口。**

## 0x02 漏洞利用
根据端口逐一突破。
