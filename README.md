# mina-test-world-2

```
zk config zkTestWorld

./make.sh vpc-create
./make.sh ...

```

```
ssh -i `cat .env_MINA_SANDBOX_KEY_FILE` ubuntu@`cat .env_MINA_SANDBOX_PUBLIC_DNS`

sudo apt-get install curl apt-transport-https ca-certificates software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt update

apt-cache policy docker-ce

sudo apt install docker-ce
sudo systemctl status docker
docker version

sudo usermod -aG docker $USER

```