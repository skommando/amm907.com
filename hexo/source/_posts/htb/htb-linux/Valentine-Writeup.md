---
title: Valentine Writeup
date: 2020-11-29 03:25:11
category: Hack The Box
---

# Valentine Writeup

![](./0.png)

## 0x01 信息收集

![](./1.png)

## 0x02 枚举

### 1、Port 22

存在 SFTP 溢出 RCE，需要登录凭证，用户名，或者私钥。
当 ssh 仅允许 sftp 时，借助此漏洞可使用 ssh 来访问系统（执行命令）。

### 2、Port 80、443
`--script vuln` 扫到 heartbleed 漏洞。

搜到一个 ASCII Hex，解码后是一个加密后的 id_rsa，用 openssh 解密，报错。
``` bash
openssl rsa -in id_rsa -out dec.key
```

用 john 破解，得到密码 `*7¡Vamos!`。
![](./5.png)

私钥应该可以直接用 ssh 连接，但是当前密码不正确，且不知道 `用户名`。

Apache httpd 2.2.22 存在 cgi-bin RCE。
路径 404？可能需要一个具体的脚本 uri，但是目前 cgi-bin 目录下没扫到脚本文件。

## 0x03 立足点

## 0x04 提权

## 0x05 攻击节点

## 0x06 学到什么 
#### 1、理解漏洞的基本用途。