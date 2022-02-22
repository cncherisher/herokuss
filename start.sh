#!/bin/sh
rm -rf SecureTunnel shadowsocks2-linux
wget -O SecureTunnel-linux-64.tar.gz https://github.com/CoiaPrant/SecureTunnel/releases/download/v${STVER}/SecureTunnel_${STVER}_linux_amd64.tar.gz
wget -O shadowsocks2-linux.tgz https://github.com/shadowsocks/go-shadowsocks2/releases/download/v${SSVER}/shadowsocks2-linux.tgz
tar -xzvf SecureTunnel-linux-64.tar.gz
rm -rf SecureTunnel-linux-64.tar.gz LICENSE README.md
chmod +x SecureTunnel
tar -xzvf shadowsocks2-linux.tgz
chmod +x shadowsocks2-linux
rm -rf shadowsocks2-linux.tgz
cat>config.json<<EOF
{
    "50000": {
        "Cert": "",
        "Key":"",
        "Paths": {
            "\/ws": "127.0.0.1:10000",
            "\/ws2": "IP:Port"
        },
        "Protocol": "cloudflare",
        "MinSpeed": 5,
        "Port": "${STPORT}"
    }
}
EOF
kill -9 $(ps -ef | grep SecureTunnel | grep -v grep | awk '{print $2}')
kill -9 $(ps -ef | grep shadowsocks2-linux | grep -v grep | awk '{print $2}')

./shadowsocks2-linux -s 'ss://AEAD_CHACHA20_POLY1305:${SSPWD}@:10000' &
./SecureTunnel -config config.json





