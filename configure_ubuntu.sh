#!/bin/bash

# This script configure ubuntu after installation
# i.e., install the programs
# Printf -----------------------------------------
# 38 --> foreground
# 48 --> background

# ------------------------------------------------------------------------------
# Script settings
# ------------------------------------------------------------------------------
# Colors
BLACK='\033[0;30m';  DGRAY='\033[1;30m'; 
RED='\033[0;31m'; 	 LRED='\033[1;31m'; 
GREEN='\033[0;32m';  LGREEN='\033[1;32m'; 
ORANGE='\033[0;33m'; YELLOW='\033[1;33m'; 
BLUE='\033[0;34m'; 	 LBLUE='\033[1;34m'; 
PURPLE='\033[0;35m'; LPURPLE='\033[1;35m'; 
CYAN='\033[0;36m'; 	 LCYAN='\033[1;36m'; 
LGRAY='\033[0;37m';  WHITE='\033[1;37m'; 
NC='\033[0m' # No Color



printf "${LBLUE}Starting script\n"
printf "---------------------------------------\n\n"


if [ $# -lt 1 ];then
	echo "You must pass a parameter option"
	echo "--fst Execute first script part"
	echo "--snd Execute second part"


# ------------------------------------------------------------------------------
# First part
# ------------------------------------------------------------------------------
elif [ "$1" == "--fst" ]; then

printf "${LBLUE}Updating system\n"
sudo apt update
sudo apt dist-upgrade -y
sudo apt clean
sudo apt autoremove -y

# ---------------------------------------

printf "${LRED}Removing snap and snap-packages\n"
sudo apt purge snapd -y

# ---------------------------------------

printf "${LGREEN}Installing apps from APT repository\n"
sudo apt install -y flameshot adb gnome-software-plugin-flatpak gnome-tweaks \
		simplescreenrecorder python3-pip python3-venv python3-dev \
		git vlc flatpak	gnome-sushi cmake 


# ---------------------------------------

printf "${LCYAN}Now I'll Restart PC to activate flatpak \
		support\nAfter that, run again with '--snd' as parameter\n"
sleep 3
reboot


# ------------------------------------------------------------------------------
# Second part of script
# ------------------------------------------------------------------------------
elif [ "$1" == "--snd" ]; then
	pushd `pwd`

	cd /tmp/

	printf "${LBLUE}Downloading packages\n"

	echo "Downloading flatpak apps"
	wget https://flathub.org/repo/appstream/com.github.lainsce.notejot.flatpakref
	wget https://flathub.org/repo/appstream/com.github.marktext.marktext.flatpakref
	wget https://flathub.org/repo/appstream/com.github.wwmm.pulseeffects.flatpakref
	wget https://flathub.org/repo/appstream/nl.hjdskes.gcolor3.flatpakref
	wget https://flathub.org/repo/appstream/org.gnome.Characters.flatpakref
	wget https://flathub.org/repo/appstream/org.libreoffice.LibreOffice.flatpakref
	wget https://flathub.org/repo/appstream/org.gimp.GIMP.flatpakref

	echo "Downloading DEB pkgs"
	wget "https://az764295.vo.msecnd.net/stable/\
	6ab598523be7a800d7f3eb4d92d7ab9a66069390/code_1.39.2-1571154070_amd64.deb"
	wget "https://ufpr.dl.sourceforge.net/project/xdman/xdm-2018-x64.tar.xz"
	wget "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
	wget "https://dl.bintray.com/boostorg/release/1.71.0/source/boost_1_71_0.tar.gz"
	wget "https://ufpr.dl.sourceforge.net/project/stacer/v1.1.0/\
	stacer_1.1.0_amd64.deb"


	# ---------------------------------------

	printf "${LGREEN}Installing downloaded Packages\n"

	echo "Installing flatpak apps"
	for i in *.flatpakref; do sudo flatpak install $i -y; done

	echo "Extracting tar files"
	tar -xmf xdm-2018-x64.tar.xz
	tar -xmf boost_1_71_0.tar.gz

	echo "Installing tar files"
	#XDM -- Xtreme download manager
	sudo ./install.sh
	# installing boost
	cd boost_1_71_0
	mkdir ${HOME}/boost_1_71_0
	./bootstrap.sh --prefix=${HOME}/boost_1_71_0
	# If you won't pass a prefix, will be istalled in /usr/local/
	./b2 install
	cd -
	echo "
# Boost
BOOST_DIR=~/boost_1_71_0

" >> ~/.bash_aliases
	# DEBs
	echo "Installing deb pkgs"
	sudo dpkg -i *.deb -y

	# ---------------------------------------

	printf "${LBLUE}Setting python environment\n"
	source python/bin/activate

	printf "${LGREEN}Installing Python libs\n"
	pip3 install scipy matplotlib pandas scikit-image scikit-learn ipython

	# ---------------------------------------

	printf "${LBLUE}Configuring user aliases\n"
	echo "# Python Venv
	source ${HOME}/python/bin/activate
	" >> ${HOME}/.bash_aliases

	# ---------------------------------------

	printf "${YELLOW}Configure keyboard shortcuts\n"
	echo "Toggle Always on Top"
	echo ">> wmctrl -r :ACTIVE: -b toggle,above"
	echo "Tasks-Stacer"
	echo ">> stacer"
	echo "Flameshot -screnshot shortcut 2"
	echo ">> flameshot gui"
	echo "Color Picker"
	echo ">> flatpak run nl.hjdskes.gcolor3"
	echo "SimpleScreenRecorder"
	echo ">> simplescreenrecorder"
	echo "FlameShot -- Screenshot"
	echo ">> flameshot gui"


	# ---------------------------------------

	printf "${YELLOW}Download and install others programs\n"
	printf "${GRAY}* Matlab\t<${LCYAN}https://drive.google.com/drive/folders/1VZ7MGFUYYaL3UDPuX38Iw4HH8zfmt9qu>"
	printf "${GRAY}* Qt\t<${LCYAN}https://www.qt.io/download-qt-installer?hsCtaTracking=99d9dd4f-5681-48d2-b096-470725510d34%%7C074ddad0-fdef-4e53-8aa8-5e8a876d6ab4>"

fi









# Sometimes you must to create symbolic link in another dirs
# /usr/bin
# /usr/include
# /usr/lib/
# For example

# For qt you must do (in bin gcc folder) 
# for i in *; do sudo ln `pwd`/${i} -sf /usr/bin/; done
# 

# In addiction, when linking symbolic not work, you can use ldconfig
# to do this, create a file in /etc/ld.so.conf.d/qt5_libs.conf
# And then, you can run sudo ldconfig
# this will set up your libraries
# In addiction, this qt5_libs.conf must contain path to lib folder in gcc 
# folder (inner installation qt5 folder).








