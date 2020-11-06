---
title: Lame Writeup
date: 2020-11-05 02:22:09
category: Hack The Box
---

# Lame Writeup

![](./Lame.png)

---

## 信息收集

上来第一件事先扫下开放端口，刚开始先用脚本把全端口跑一遍。

在目录下新建一个 nmap 文件夹用来放扫描结果，整个渗透过程中可能存在多阶段扫描，很多结果需要分类。

第一步扫描可以取名为 `init.*`，放在 `nmap/` 下。
``` bash
nmap -sC -sV -O -p- -oA nmap/init 10.10.10.3
```
- **-sC**: 会执行默认脚本
- **-sV**: 检测开放端口的服务版本
- **-O**: 检测操作系统
- **-p-**: 1-65535 全端口探测
- **-oA**: 输出所有格式的信息并存为 nmap/init.*

嫌速度慢可以先扫端口，然后根据开放端口扫详细。
``` bash
nmap -p- 10.10.10.3
nmap -sC -sV -O -p xx,xx,xx -oA nmap/init 10.10.10.3
```
