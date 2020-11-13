---
title: HTB Environment
date: 2020-11-05 05:39:04
category: Hack The Box 
---
# HTB Environment

## 1、安装 openvpn 
。。。

## 2、连接 VPN 进入实验室环境

启动

```
openvpm amm907.ovpn
```

![](./1.png)
看到 `Initialization Sequence Completed` 字样说明连接成功。

然后查看本地 IP
```
ip a
``` 
可以看到新增的 tun0 内网地址 `10.10.14.11`，即是实验室环境 ip。

![](./2.png)

> ***常见异常***
> *openvpn 断开后留下 tun0 接口，以下命令删除。*
> *`ip link delete tun0`*