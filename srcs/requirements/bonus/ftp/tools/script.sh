#!/bin/bash

if id "$FTP_USER" &>/dev/null; then
    echo "User $FTP_USER already exists"
else
    useradd -m -d /var/www/html -s /bin/bash $FTP_USER
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
    echo "$FTP_USER" | tee -a /etc/vsftpd.userlist
fi

usermod -aG www-data $FTP_USER
chown -R $FTP_USER:www-data /var/www/html

mkdir -p /var/run/vsftpd/empty

echo "Starting FTP Server..."
exec /usr/sbin/vsftpd /etc/vsftpd.conf