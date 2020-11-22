---
title: Beep Writeup
date: 2020-11-22 00:01:49
category: Hack The Box
---

# Beep Writeup

![](./0.png)

## 0x01 信息收集

![](./1.png)

## 0x02 漏洞利用

玩法非常多。

0、lfi-password
https://10.10.10.7/vtigercrm/graph.php?current_language=../../../../../../../..//etc/amportal.conf%00&module=Accounts&action
google 找到 elasxtic 配置文件位置。
https://10.10.10.7/vtigercrm/graph.php?current_language=../../../../../../../../etc/asterisk/manager.conf%00&module=Accounts&action
登入应用。
admin/jEhdIekWmdjE
使用有效 cookie 通过上传漏洞([CVE-2015-6000](https://www.exploit-db.com/exploits/38345))拿到 webshell。上传不成功

01、lfi-ssh root@10.10.10.7 拒绝访问

1、remote code injection

38091 利用不成功
18650 根据报错枚举爆破，得到 extension 233，getshell。涉及到两个工具，其机理和运用还没深入研究。遇到ssl报错的问题，已经解决。其实可以通过 bp 发包避开这个问题。
https://github.com/EnableSecurity/sipvicious
https://github.com/EnableSecurity/sipvicious/wiki/SVWar-Usage

2、lfi-email webshell

3、shellshock
没有回显，用 sleep 10，盲注原理。

![](./7.png)

## 0x03 提权

![](./8.png)

## 0x04 攻击节点


## 0x05 学到什么
#### 1、EXP 下下来就可以用的可能性非常小，需要先理解脚本内容，再修改、执行。
- 作者可能做了处理避免直接执行（php：<?eval xxx?>）
- 环境、编码等因素导致各种报错
- 出于安全考虑
#### 2、EXP 的使用能一次过当然最好，遇到异常回显，认真分析原因，修改。比如之前的 cgi 漏洞要先有一个 echo 才有回显，还有这次的 extension 枚举，报错里已经提示了 line busy。
#### 3、邮件 + LFI getshell 非常秀，多理解，在未来类似的场景下尝试使用。