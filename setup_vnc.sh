#!/bin/bash
read -p 'User: ' vnc_user
read -p 'Port: ' vnc_port

# create config file
touch tmp.file
echo "[Unit]" >> tmp.file 
echo "Description=VNC Service $vnc_user\:$vnc_port"  >> tmp.file
echo "After=syslog.target network.target"  >> tmp.file
echo "[Service]" >> tmp.file
echo "Type=forking" >> tmp.file
echo "ExecStartPre=/bin/sh -c '/usr/bin/vncserver -kill %i > /dev/null 2>&1 || :'" >> tmp.file
echo "ExecStart=/sbin/runuser -l $vnc_user -c \"/usr/bin/vncserver %i\"" >> tmp.file

if [$vnc_user = 'root'] then
  echo "PIDFile=/home/$vnc_user/.vnc/%H%i.pid" >> tmp.file
else 
  echo "PIDFile=/$vnc_user/.vnc/%H%i.pid" >> tmp.file
fi

echo "ExecStop=/bin/sh -c '/usr/bin/vncserver -kill %i > /dev/null 2>&1 || :'" >> tmp.file
echo "[Install]" >> tmp.file
echo "WantedBy=multi-user.target" >> tmp.file

mv tmp.file /etc/systemd/system/vncserver@\:$vnc_port.service

# setup vnc-service
if [$vnc_user = 'root'] then
  vncserver
  systemctl daemon-reload
  systemctl enable vncserver@:$vnc_port.service
  systemctl start vncserver@:$vnc_port.service
else
  echo "now login to user $vnc_user"
  echo "running\: vncserver"
  echo "back to root user\: exit"
  echo "reload daemon\: systemctl daemon-reload"
  echo "enable service\: systemctl enable vncserver@\:$vnc_port.service"
  echo "start service\: systemctl enable vncserver@\:$vnc_port.service"
fi

_vnc_port = 5900 + $vnc_port
echo "dont forget to open port $_vnc_port" 
echo "nano /etc/sysconfig/iptables -c"
echo "add the line"
echo "-A INPUT -p tcp -m state --state NEW -m tcp --dport $_vnc_port -j ACCEPT"
echo "restart\: service iptables restart"
