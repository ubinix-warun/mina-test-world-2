
# Setup MINA - Block Producer

## Install MINA Berkeley for TestWorld 2.0 

```bash
sudo rm /etc/apt/sources.list.d/mina*.list
echo "deb [trusted=yes] http://packages.o1test.net/ bullseye rampup" | \
	sudo tee /etc/apt/sources.list.d/mina-rampup.list
sudo apt-get update
sudo apt-get install -y mina-berkeley=2.0.0rampup7-4a0fff9
# sudo apt-get install -y mina-berkeley=2.0.0rampup6-4061884
# sudo apt-get install -y mina-berkeley=2.0.0rampup5-55b7818
```

FYI, Recommend to use Debian 11 (bullseye) [AWS Debian 11](https://aws.amazon.com/marketplace/pp/prodview-l5gv52ndg5q6i)

## Setup user and secret keys.

```bash
sudo adduser mina 
# set password your mina

sudo mkdir /mina
sudo chown mina:mina /mina

sudo mkdir /mina/keys
sudo chmod 700 /mina/keys

```

### Import account key to /mina/keys/my-wallet

```bash
sudo nano /mina/keys/my-wallet
sudo chmod 600 /mina/keys/my-wallet

sudo nano /mina/keys/my-wallet.pub
# public key

```

### Generate libp2p keys on /mina/keys/keys

```bash
sudo chown mina:mina /mina -R

sudo su mina
# su to mina user session

cd ~

mina libp2p generate-keypair -privkey-path /mina/keys/keys

exit
# exit from mina user.

```

## Config. MINA daemon and Setting pass key.

```bash
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
ExecStart=/usr/local/bin/mina daemon --log-json --log-snark-work-gossip true --internal-tracing \
--insecure-rest-server --log-level Debug --file-log-level Debug \
--config-directory /mina/.mina-config/ --external-ip $(wget -qO- eth0.me) \
--itn-keys  f1F38+W3zLcc45fGZcAf9gsZ7o9Rh3ckqZQw6yOJiS4=,\
6GmWmMYv5oPwQd2xr6YArmU1YXYCAxQAxKH7aYnBdrk=,\
ZJDkF9EZlhcAU1jyvP3m9GbkhfYa0yPV+UdAqSamr1Q=,\
NW2Vis7S5G1B9g2l9cKh3shy9qkI1lvhid38763vZDU=,\
Cg/8l+JleVH8yNwXkoLawbfLHD93Do4KbttyBS7m9hQ= \
--itn-graphql-port 3089 --uptime-submitter-key  /mina/keys/my-wallet \
--uptime-url https://block-producers-uptime-itn.minaprotocol.tools/v1/submit --metrics-port 10001 \
--enable-peer-exchange  true --libp2p-keypair /mina/keys/keys --log-precomputed-blocks true --max-connections 200 \
--peer-list-url  https://storage.googleapis.com/seed-lists/testworld-2-0_seeds.txt --generate-genesis-proof  true \
--block-producer-key /mina/keys/my-wallet --node-status-url https://nodestats-itn.minaprotocol.tools/submit/stats  \
--node-error-url https://nodestats-itn.minaprotocol.tools/submit/stats \
--file-log-rotations 500 --itn-max-logs 10000
ExecStop=/usr/local/bin/mina client stop-daemon

[Install]
WantedBy=default.target
EOF
```

## Activate MINA daemon with systemctl

 > Enable port 3089 for create transaction generation and stress test the network. 

```bash
sudo systemctl daemon-reload
sudo systemctl enable mina
sudo loginctl enable-linger
sudo systemctl restart mina

sudo systemctl status mina

```

## Show MINA node status

```bash
mina client status

--
Mina daemon status
-----------------------------------

Global number of accounts:                     201739
Block height:                                  1517
Max observed block height:                     1517
Max observed unvalidated block height:         1517
Local uptime:                                  4d10h56m53s
Ledger Merkle root:                            jxR4PgDyBMbYvs3VsaQJ4HrSRmWs4ixZRNg4LXgKA7e2n82cQwc
Protocol state hash:                           3NKSxoEAEXvpmDPrhYm5f3ggvwn4dwJEqvbTK22uXumNXpdpR9o1
Chain id:                                      332c8cc05ba8de9efc23a011f57015d8c9ec96fac81d5d3f7a06969faf4bce92
Git SHA-1:                                     55b78189c46e1811b8bdb78864cfa95409aeb96a
Configuration directory:                       /mina/.mina-config/
Peers:                                         101
User_commands sent:                            0
SNARK worker:                                  None
SNARK work fee:                                100000000
Sync status:                                   Synced
Catchup status:                                
	To build breadcrumb:           0
	To initial validate:           0
	Finished:                      514
	To download:                   0
	Waiting for parent to finish:  0
	To verify:                     0

Block producers running:                       1 (<>)
Coinbase receiver:                             Block producer
Best tip consensus time:                       epoch=0, slot=2140
Best tip global slot (across all hard-forks):  2140
Next block will be produced in:                in 1.57d for slot: 2894 slot-since-genesis: 2894 (Generated from consensus at slot: 1298 slot-since-genesis: 1298)
Consensus time now:                            epoch=0, slot=2140
Consensus mechanism:                           proof_of_stake
Consensus configuration:                       
	Delta:                     0
	k:                         290
	Slots per epoch:           7140
	Slot duration:             3m
	Epoch duration:            14d21h
	Chain start timestamp:     2023-10-17 16:01:01.000000Z
	Acceptable network delay:  3m

Addresses and ports:                           
	External IP:    52.197.73.178
	Bind IP:        0.0.0.0
	Libp2p PeerID:  <>
	Libp2p port:    8302
	Client port:    8301

Metrics:                                       
	block_production_delay:             7 (6 0 0 0 0 0 0)
	transaction_pool_diff_received:     1
	transaction_pool_diff_broadcasted:  0
	transactions_added_to_pool:         6932
	transaction_pool_size:              0
	snark_pool_diff_received:           16
	snark_pool_diff_broadcasted:        0
	pending_snark_work:                 0
	snark_pool_size:                    2764


```

## Show pretty JSON log with fblog

```bash
wget https://github.com/brocode/fblog/releases/download/v4.4.0/fblog
chmod +x fblog
sudo mv fblog /usr/local/bin

tail -n 1000 -f /mina/.mina-config/mina.log | fblog -c metadata -F '$key'

```

## (Extra) config log and run journalctl 1d.

```bash
# clean journalctl
journalctl --vacuum-time=1d

# config daily logrotate
sudo vi /etc/logrotate.d/rsyslog
# change weekly => daily
sudo systemctl restart logrotate.service
sudo systemctl restart logrotate.timer

# flush cache
sync; echo 1 > /proc/sys/vm/drop_caches 
sync; echo 2 > /proc/sys/vm/drop_caches 
sync; echo 3 > /proc/sys/vm/drop_caches

```

# Credit 

* [Core-Node-Team/Testnet-TR](https://github.com/Core-Node-Team/Testnet-TR/blob/main/Mina/Mina-Eng.md)
