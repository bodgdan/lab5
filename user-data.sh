#!/bin/bash

apt-get update -y
apt-get install -y systemd mc vim

mkdir -p /root/folder1
mkdir -p /root/folder2

cat <<'EOF' | sudo tee /root/mover-script.sh
#!/bin/bash

while true
do
    if [ "$(ls -A /root/folder1)" ]; then
        mv -fv /root/folder1/* /root/folder2/
    fi 
    sleep 1
done
EOF

cat <<'EOF' | sudo tee /lib/systemd/system/bad-daemon.service
[Unit]
Description=Daemon which move files between folders

[Service]
Type=simple
ExecStart=/bin/bash /root/mover-script.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start bad-daemon
systemctl enable bad-daemon