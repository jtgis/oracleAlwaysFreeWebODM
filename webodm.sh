sudo apt update
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo apt install -y git python2 python-pip
sudo apt install pip
docker-compose --version
sudo pip install docker-compose
git clone https://github.com/OpenDroneMap/WebODM
cd WebODM
sudo ./webodm.sh start --port 8000 --detached
sudo netstat -lntp
sudo iptables -S INPUT
sudo iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 8000 -j ACCEPT
sudo iptables -D INPUT -j REJECT --reject-with icmp-host-prohibited
sudo netfilter-persistent save

