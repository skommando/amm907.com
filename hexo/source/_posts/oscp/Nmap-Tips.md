---
title: Nmap Tips
date: 2020-11-07 15:10:35
category: OSCP
---

# 记录一下 nmap 技巧

`nmap` 常用参数无非就那几个，但是在不同场景下，综合扫描速度和探测目标，用不同的参数组合应对。

## 0x01 参数和结果

### 1、一些参数的结果比较
- 左边：`-sC -sV -O`
- 右边：`-A`

![](./1.png)

右边 `-A` 多出了 5 个结果：
- **Device type**: 设备类型
- **Running (JUST GUESSING)**: 目标操作系统猜测
- **OS CPE**: 通用平台枚举项（Common Platform Enumeration），对识别出的软件、硬件和操作系统的一种命名方式
- **Network Distance**: 与目标间的网络距离，单位是节点
- **TRACEROUTE**: 到达目标的路由跟踪

1. 其中 `Device type`、`Running`、`OS CPE` 属于 `-O` 参数的输出，即 `操作系统探测`，有时候这三个结果不会出现，出现的原因我理解是由于扫描不精确导致输出一些枚举项。
2. `Network Distance`、`TRACEROUTE` 属于 `–traceroute` 参数的输出。