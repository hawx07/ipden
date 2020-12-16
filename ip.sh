
gen_3proxy() {
    cat <<EOF
nscache 65536
nserver 8.8.8.8
nserver 8.8.4.4

config /conf/3proxy.cfg
monitor /conf/3proxy.cfg

log /logs/3proxy-%y%m%d.log D
rotate 60
counter /count/3proxy.3cf

users usernameproxy:CL:passwordforproxy

include /conf/counters
include /conf/bandlimiters

auth iponly
allow * 188.165.205.32,46.105.101.74,144.217.64.10,158.69.126.183,144.217.183.123,46.196.206.142,173.208.188.210,135.181.76.190,104.37.175.241,24.133.173.189,198.204.253.146

EOF
}


yum -y install gcc net-tools bsdtar zip git
yum -y groupinstall "Development Tools"

git clone https://github.com/z3apa3a/3proxy
cd 3proxy
ln -s Makefile.Linux Makefile
make
sudo make install

cd /etc/3proxy/conf
mv 3proxy.cfg 3proxy.cfg.bak
gen_3proxy >3proxy.cfg
service 3proxy start
cd
wget https://raw.githubusercontent.com/kripul/c0de/master/3proxygencfg.sh
bash 3proxygencfg.sh
cd
cat config.cfg >> /etc/3proxy/conf/3proxy.cfg
echo "flush" >> /etc/3proxy/conf/3proxy.cfg
service 3proxy restart
