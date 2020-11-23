---
title: Nibbles Writeup
date: 2020-11-22 21:13:53
category: Hack The Box
---

# Nibbles Writeup

![](./0.png)

## 0x01 信息收集

![](./1.png)

## 0x02 漏洞利用

扫目录，打开得到版本号。
根据目录扫描结果去看一些文件。
> 下个开源的包，搜版本号，记住位置，在靶机上找这个位置，得到版本号。

![](./8.png)
![](./2.png)
![](./12.png)
![](./9.png)
![](./3.png)
![](./10.png)
![](./11.png)
![](./5.png)
![](./6.png)
http://10.10.10.75/nibbleblog/content/private/plugins/my_image/image.php

![](./4.png)
![](./7.png)

## 0x03 提权


![](./13.png)
![](./14.png)
![](./16.png)
![](./17.png)

## 0x04 攻击节点
#### 端口扫描 -> 80.网页源码找到站点 -> 目录扫到入口+user -> 弱口令登录 -> 文件上传 getshell(nibbler) -> sudo 配置不当提权(root)

## 0x05 学到什么
#### 1、弹 shell 的时候，一个不行就试另一个，经常有这种坑估计卡你一两下。
#### 2、同个工具可能存在多个版本，一个不行就试另一个，比如 python、python3。
#### 3、【sudo vs hosts】本题多了一个难点：sudo 和 host 的关系，虽然没有直接影响解体，但是使用 sudo 的时候卡顿容易让人以为搞错了。这个要研究下。