---
title: Common Problems
date: 2020-11-22 01:19:22
category: WEAPONRY
---

# 常见问题记录

#### Shell curl 命令报错：(60) SSL certificate problem: self signed certificate

curl 需要加上 -k，wget 需要加上 --no-check-certificate
``` bash
curl -v -k https://amm907.com
wget --no-check-certificate https://amm907.com
```


#### Shell curl 命令报错: (35) error:1425F102:SSL routines:ssl_choose_client_version:unsupported protocol

OPENSSL_CONF=./openssl_allow_tls1.0.cnf curl -v https://amm907.com

``` bash
vi openssl_allow_tls1.0.cnf
openssl_conf = openssl_init

[openssl_init]
ssl_conf = ssl_sect

[ssl_sect]
system_default = system_default_sect

[system_default_sect]
CipherString = DEFAULT@SECLEVEL=1
```
