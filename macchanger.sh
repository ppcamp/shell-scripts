# Mac change # macchanger (u can download also)

if [ $# -lt 1 ];then
    INTERFACE='enp2s0f0'
    MAC='2C:76:8A:BB:D4:52'
else
    INTERFACE=$1
    MAC=$2
fi

sudo ifconfig $INTERFACE down & \
sudo ifconfig $INTERFACE hw ether $MAC & \
sudo ifconfig $INTERFACE up

printf "\033[1;32mMac changed sucessufuly! \033[0m \n"
echo "Current address: ${MAC}"
# ./macchanger.sh enp2s0f0 2C:76:8A:BB:D4:52
# ./macchanger.sh enp2s0f0 B8:AE:ED:82:FF:80

