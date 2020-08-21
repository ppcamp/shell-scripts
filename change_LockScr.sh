RED='\033[0;31m'; NC='\033[0m'

string="#lockDialogGroup {
  background: #4f194c url(noise-texture.png);
  background-repeat: repeat; }"


if [ $# -lt 1 ]; then
    printf "${RED}You must pass a parameter option\n${NC}"
    echo 'Ex.: wallapaper.jpg'
    echo 'Ex.: wallpaper.png 9A80CD' #432974 #B01037 #20A44B
else
    sudo cp "$1" /usr/share/backgrounds/
newString="#lockDialogGroup {
  background: #$2 url(file:///usr/share/backgrounds/${1});
  background-repeat: no-repeat;
  background-size: cover;
  background-position: center; 
}"
    sudo sed -i 's/${string}/${newString}/g' "/etc/alternatives/gdm3.css"
 
fi
