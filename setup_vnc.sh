#!/bin/bash
read -p 'User: ' vnc_user
read -p 'Port: ' vnc_port

yum install vnc-server -y

# =============================
touch tmp.file
echo "[Unit]" >> tmp.file 
echo "Description=Remote desktop service (VNC)"  >> tmp.file
echo "After=syslog.target network.target"  >> tmp.file

echo "[Service]" >> tmp.file
echo "Type=forking" >> tmp.file
echo "ExecStartPre=/bin/sh -c '/usr/bin/vncserver -kill %i > /dev/null 2>&1 || :'" >> tmp.file
echo "PIDFile=/home/$vnc_user/.vnc/%H%i.pid" >> tmp.file
echo "ExecStop=/bin/sh -c '/usr/bin/vncserver -kill %i > /dev/null 2>&1 || :'" >> tmp.file

echo "[Install]" >> tmp.file
echo "WantedBy=multi-user.target" >> tmp.file

mv tmp.file /etc/systemd/system/vncserver@\:$vnc_port.service

#cat tmp.file
# =============================

#su - $vnc_user
vncserver
#su
systemctl daemon-reload
systemctl enable vncserver@:$vnc_port.service
systemctl start vncserver@:$vnc_port.service

# dont forget to open port
# nano /etc/sysconfig/iptables -c
# add the line
# -A INPUT -p tcp -m state --state NEW -m tcp --dport 590$vnc_port -j ACCEPT
# service iptables restart
