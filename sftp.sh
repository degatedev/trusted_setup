#!/bin/bash

sed -i 's/Subsystem/#Subsystem/g' /etc/ssh/sshd_config
sed -i '$a\Subsystem sftp internal-sftp\nMatch group sftpgroup\nChrootDirectory /data/sftp\nForceCommand internal-sftp\nAllowTcpForwarding no\nX11Forwarding no' /etc/ssh/sshd_config
/usr/sbin/service ssh restart

mkdir -p /data/sftpkey/
mkdir -p /data/sftp/sftpuser0
mkdir -p /data/sftp/sftpuser1
mkdir -p /data/sftp/sftpuser2
mkdir -p /data/sftp/sftpuser3
mkdir -p /data/sftp/sftpuser4
mkdir -p /data/sftp/sftpuser5
mkdir -p /data/sftp/sftpuser6

/usr/sbin/groupadd sftpgroup
/usr/sbin/useradd -g sftpgroup -d /home/sftpuser1 -m sftpuser1
/usr/sbin/useradd -g sftpgroup -d /home/sftpuser2 -m sftpuser2
/usr/sbin/useradd -g sftpgroup -d /home/sftpuser3 -m sftpuser3
/usr/sbin/useradd -g sftpgroup -d /home/sftpuser4 -m sftpuser4
/usr/sbin/useradd -g sftpgroup -d /home/sftpuser5 -m sftpuser5
/usr/sbin/useradd -g sftpgroup -d /home/sftpuser6 -m sftpuser6

/usr/bin/su sftpuser1 -c "/usr/bin/ssh-keygen -f ~/.ssh/id_rsa -P '' -q"
/usr/bin/su sftpuser2 -c "/usr/bin/ssh-keygen -f ~/.ssh/id_rsa -P '' -q"
/usr/bin/su sftpuser3 -c "/usr/bin/ssh-keygen -f ~/.ssh/id_rsa -P '' -q"
/usr/bin/su sftpuser4 -c "/usr/bin/ssh-keygen -f ~/.ssh/id_rsa -P '' -q"
/usr/bin/su sftpuser5 -c "/usr/bin/ssh-keygen -f ~/.ssh/id_rsa -P '' -q"
/usr/bin/su sftpuser6 -c "/usr/bin/ssh-keygen -f ~/.ssh/id_rsa -P '' -q"

cd /home/sftpuser1/.ssh && cat id_rsa.pub >authorized_keys
cd /home/sftpuser2/.ssh && cat id_rsa.pub >authorized_keys
cd /home/sftpuser3/.ssh && cat id_rsa.pub >authorized_keys
cd /home/sftpuser4/.ssh && cat id_rsa.pub >authorized_keys
cd /home/sftpuser5/.ssh && cat id_rsa.pub >authorized_keys
cd /home/sftpuser6/.ssh && cat id_rsa.pub >authorized_keys

cp /home/sftpuser1/.ssh/id_rsa /data/sftpkey/sftpuser1.key && chmod 600 /data/sftpkey/sftpuser1.key
cp /home/sftpuser2/.ssh/id_rsa /data/sftpkey/sftpuser2.key && chmod 600 /data/sftpkey/sftpuser2.key
cp /home/sftpuser3/.ssh/id_rsa /data/sftpkey/sftpuser3.key && chmod 600 /data/sftpkey/sftpuser3.key
cp /home/sftpuser4/.ssh/id_rsa /data/sftpkey/sftpuser4.key && chmod 600 /data/sftpkey/sftpuser4.key
cp /home/sftpuser5/.ssh/id_rsa /data/sftpkey/sftpuser5.key && chmod 600 /data/sftpkey/sftpuser5.key
cp /home/sftpuser6/.ssh/id_rsa /data/sftpkey/sftpuser6.key && chmod 600 /data/sftpkey/sftpuser6.key

/usr/bin/chown sftpuser1 -R /data/sftp/sftpuser0
/usr/bin/chmod 500 -R /data/sftp/sftpuser0
/usr/bin/chown sftpuser1:sftpgroup -R /data/sftp/sftpuser1
/usr/bin/chmod 350 -R /data/sftp/sftpuser1
/usr/bin/chown sftpuser2:sftpgroup -R /data/sftp/sftpuser2
/usr/bin/chmod 350 -R /data/sftp/sftpuser2
/usr/bin/chown sftpuser3:sftpgroup -R /data/sftp/sftpuser3
/usr/bin/chmod 350 -R /data/sftp/sftpuser3
/usr/bin/chown sftpuser4:sftpgroup -R /data/sftp/sftpuser4
/usr/bin/chmod 350 -R /data/sftp/sftpuser4
/usr/bin/chown sftpuser5:sftpgroup -R /data/sftp/sftpuser5
/usr/bin/chmod 350 -R /data/sftp/sftpuser5
/usr/bin/chown sftpuser6:sftpgroup -R /data/sftp/sftpuser6
/usr/bin/chmod 350 -R /data/sftp/sftpuser6
