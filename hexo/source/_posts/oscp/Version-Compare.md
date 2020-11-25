---
title: Version Compare
date: 2020-11-14 00:06:57
category: OSCP
---

# 版本相关
版本查询，日期查询等相关的信息收集操作。


## 如何快速查找版本发布日期
Google 搜：name version changelog
比如，要找 pfsense 2.1.3 的发布日期，以便与补丁、exp 啥的比对，google 搜：
``` bash
pfsense 2.1.3 changelog
```
![](./1.png)


## 一个发现漏洞版本的技巧，比较少用，待学习。
通过将 当前 OS 版本+当前端口服务 和 同版本 OS 发版时的相应服务比较，判断当前服务是否为低版本。
比如 4ubuntu2.2 + apache 2.4.18 与 发版时ubuntu2.2 + apache 2.4.1x 比较。大概是这样，不是很清楚，先记一下。