sudo apt update && sudo apt install -y curl zstd

curl --fail --location https://ollama.com/download/ollama-linux-amd64.tar.zst -o /tmp/ollama-linux-amd64.tar.zst
file /tmp/ollama-linux-amd64.tar.zst

sudo tar -xv --zstd -C /usr -f /tmp/ollama-linux-amd64.tar.zst
rm /tmp/ollama-linux-amd64.tar.zst

sudo useradd -r -s /bin/false -U -m -d /usr/share/ollama ollama
sudo usermod -a -G ollama $(whoami)

cat <<'EOF' | sudo tee /etc/systemd/system/ollama.service >/dev/null
[Unit]
Description=Ollama Service
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/usr/bin/ollama serve
User=ollama
Group=ollama
Restart=always
RestartSec=3
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now ollama
systemctl status ollama --no-pager
ollama -v
