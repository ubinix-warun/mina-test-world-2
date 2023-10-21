
# Setup MINA - Block Producer

## Install MINA Berkeley for TestWorld 2.0 

```
sudo rm /etc/apt/sources.list.d/mina*.list
echo "deb [trusted=yes] http://packages.o1test.net/ bullseye rampup" | sudo tee /etc/apt/sources.list.d/mina-rampup.list
sudo apt-get update
sudo apt-get install -y mina-berkeley=2.0.0rampup5-55b7818
```

FYI, Recommend to use Debian 11 (bullseye)

## Setup user and secret keys.

```
sudo adduser mina 
# set password your mina 

```


```
sudo mkdir /mina
sudo chown mina:mina /mina

sudo mkdir /mina/keys
sudo chmod 700 /mina/keys

```

```
sudo nano /mina/keys/my-wallet

sudo chmod 600 /mina/keys/my-wallet

```

```
sudo nano /mina/keys/my-wallet.pub

```

```
sudo chown mina:mina /mina -R
sudo su mina

cd ~

mina libp2p generate-keypair -privkey-path /mina/keys/keys

exit

```

## Config. MINA daemon

```
sudo tee /usr/lib/systemd/system/mina.service > /dev/null << EOF
[Unit]
Description=Mina Daemon Service
After=network.target
StartLimitIntervalSec=60
StartLimitBurst=3

[Service]
Environment="PEERS_LIST_URL=https://storage.googleapis.com/seed-lists/testworld-2-0_seeds.txt"
Environment="LOG_LEVEL=Info"
Environment="FILE_LOG_LEVEL=Debug"
Environment="MINA_PRIVKEY_PASS=<>"
Environment="UPTIME_PRIVKEY_PASS=<>"
Environment="RAYON_NUM_THREADS=6"
Environment="MINA_LIBP2P_PASS=<>"
User=mina
Group=mina
Type=simple
Restart=always
RestartSec=30
ExecStart=/usr/local/bin/mina daemon --log-json --log-snark-work-gossip true --internal-tracing --insecure-rest-server --log-level Debug --file-log-level Debug --config-directory /mina/.mina-config/ --external-ip $(wget -qO- eth0.me) \
--itn-keys  f1F38+W3zLcc45fGZcAf9gsZ7o9Rh3ckqZQw6yOJiS4=,6GmWmMYv5oPwQd2xr6YArmU1YXYCAxQAxKH7aYnBdrk=,ZJDkF9EZlhcAU1jyvP3m9GbkhfYa0yPV+UdAqSamr1Q=,NW2Vis7S5G1B9g2l9cKh3shy9qkI1lvhid38763vZDU=,Cg/8l+JleVH8yNwXkoLawbfLHD93Do4KbttyBS7m9hQ= \
--itn-graphql-port 3089 --uptime-submitter-key  /mina/keys/my-wallet --uptime-url https://block-producers-uptime-itn.minaprotocol.tools/v1/submit --metrics-port 10001 \
--enable-peer-exchange  true --libp2p-keypair /mina/keys/keys --log-precomputed-blocks true --max-connections 200 \
--peer-list-url  https://storage.googleapis.com/seed-lists/testworld-2-0_seeds.txt --generate-genesis-proof  true \
--block-producer-key /mina/keys/my-wallet --node-status-url https://nodestats-itn.minaprotocol.tools/submit/stats  --node-error-url https://nodestats-itn.minaprotocol.tools/submit/stats \
--file-log-rotations 500
ExecStop=/usr/local/bin/mina client stop-daemon

[Install]
WantedBy=default.target
EOF
```

## Activate MINA daemon!

```
sudo systemctl daemon-reload
sudo systemctl enable mina
sudo loginctl enable-linger
sudo systemctl restart mina

sudo systemctl status mina

```


## Check MINA daemon

```
mina client status

```

# Credit 

* [Core-Node-Team/Testnet-TR](https://github.com/Core-Node-Team/Testnet-TR/blob/main/Mina/Mina-Eng.md)
