---
title: KALI Deploy
date: 2020-11-05 05:40:57
category: WEAPONRY
---

# KALI Deploy

自然是选择 KALI 作为工具系统，初始化的配置较为繁琐，这里例举一下常用的配置，最后整理个（尽量）一键脚本。

## 这里讲下 KALI 安装时基础配置，持续更新

### apt 源相关

#### 包管理工具
``` bash
apt-get install aptitude 
```

### 安全工具

#### MSF
自带 `MSF5`，我们要升级成 `MSF6`。
用 `msfupdate` 更新，被告知不再支持，改用 `apt update; apt install metasploit-framework`。

然而执行一半突然停了，啥也没报，然后 msf 打不开，也没更上，我佛了。

**遇事不决就重装，问题解决。**
``` bash
apt remove metasploit-framework
curl https://raw.githubusercontent.com:443/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall
```

#### 多种工具
``` bash
apt-get install -y gobuster, steghide, strace, ltrace
```

#### 脚本配置
**预装了 python2/3、pip3 但没有 pip2。**
``` bash
wget https://bootstrap.pypa.io/2.6/get-pip.py
python2 get-pip.py
pip2 -V
pip2 install --upgrade pip
# 替换原 pip(3)
mv /usr/local/bin/pip /usr/local/bin/pip.bk
ln -s /usr/local/bin/pip2 /usr/local/bin/pip
```
![](./2.png)

**组件安装**
``` bash
# pip2
pip install paramiko requests
# pip3
pip install paramiko
```
> **难搞的 pwntools，目前安装报错**
> ``` bash
> pip install -U setuptools
> pip install cryptography==2.5                               # 2.5 适配当时安装的版本，按理说越高越好
> pip install pwntools                                        # 报错
> pip install pwntools -i https://www.piwheels.org/simple/    # 报错
> ```

#### 信息收集相关
apt install seclists curl enum4linux gobuster nbtscan nikto nmapomesixtyone oscanner smbclient smbmap smtp-user-enum snmp sslscan sipvicious tnscmd10g whatweb wkhtmltopdf

#### 需要解压的文件
gzip -d /usr/share/wordlist/rockyou.txt.gz

### 辅助工具
#### Docker
``` bash
curl -sSL https://get.daocloud.io/docker | sh                           # 国内 daocloud
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun      # 官方
curl -sSL http://acs-public-mirror.oss-cn-hangzhou.aliyuncs.com/docker-engine/internet | sh -   # 阿里云
```

### 杂七杂八的配置

#### 终端外观
直接在终端选项是改不了的，因为终端正在打开，改完了还会被覆盖，应该`关闭终端，修改配置文件`。
- 图标：goterminal
- 字体：关闭终端后，修改配置 `.config/qterminal.org/qterminal.ini`
``` java
fontFamily=Dejavu Sans Mono
fontSize=11
```

