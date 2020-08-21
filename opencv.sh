# Install OpenCV3 on Ubuntu

# set(CMAKE_PREFIX_PATH "~/Qt/5.12.5/gcc_64/lib/cmake")
# set(QT_CMAKE_DIR "~/Qt/5.12.5/gcc_64/lib/cmake")

# Based on <https://github.com/spmallick/learnopencv/blob/master/\
#         InstallScripts/installOpenCV-3-on-Ubuntu-18-04.sh>

# ------------------------------------------------------------------------------
# Script Settings --------------------------------------------------------------
# ------------------------------------------------------------------------------
LRED='\033[0;31m'; LGREEN='\033[0;32m'; 
NColor='\033[0m';  YELLOW='\033[0;33m'; 
LINE='-------------------------------------------------------------------------'
WORK_FOLDER='/tmp'
SINSTALL_PATH=${HOME}/OpenCv/
QT5_DIR=~/Qt/5.12.5/gcc_64/lib/cmake
EIGEN3_INCLUDE_DIR=/usr/local/include/eigen3/

# ------------------------------------------------------------------------------
# Starting ---------------------------------------------------------------------
# ------------------------------------------------------------------------------
if [ $# -lt 1 ];then
    printf "${LRED}Error, you must pass a opencv version.\n\
            ${NColor}Default 3.4.7.\n"
    exit 1

else
    pushd `pwd`
    printf "\n${LGREEN}Starting OpenCv Script.\n${NColor}Version: $1\n\n"
    # Similar to save aux variable CPWD=`pwd`
    
    printf "${YELLOW}Step 1: Update packages\n${LINE}${NColor}\n"
    sudo apt update
    sudo apt upgrade
    
    printf "\n\n${YELLOW}Step 2: Install OS libraries\n${LINE}${NColor}\n"
    sleep 2
    sudo apt -y remove x264 libx264-dev
    ## Install dependencies
    sudo apt -y install build-essential checkinstall cmake pkg-config yasm \
                        git gfortran libjpeg8-dev libpng-dev
    # Add repository to download jasper
    sudo add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
    sudo apt -y update
    sudo apt -y install libjasper1 libtiff-dev
    # You can also add a ppa manually,
    # cd /etc/apt/sources.list.d/
    # sudo echo "deb http://security.ubuntu.com/ubuntu xenial-security main" > ppaName.list
    #
    # Libjasper for arm64 processors must be installed manually,
    # you can search for it in launchpad website
    # https://launchpad.net/ubuntu/xenial/arm64/libjasper-dev/1.900.1-debian1-2.4ubuntu1.2
    # https://launchpad.net/ubuntu/xenial/arm64/libjasper-dev/1.900.1-debian1-2.4ubuntu1
    
    
    sudo apt -y install libavcodec-dev libavformat-dev libswscale-dev \
                        libdc1394-22-dev libxine2-dev libv4l-dev \
                        libgtk2.0-dev libtbb-dev libatlas-base-dev libfaac-dev \
                        libmp3lame-dev libtheora-dev libvorbis-dev \
                        libxvidcore-dev libopencore-amrnb-dev \
                        libopencore-amrwb-dev libavresample-dev x264 v4l-utils \
                        libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
    # Libv4l error
    # sudo ln -s ../libv4l1-videodev.h videodev.h 

    printf "\n\n${YELLOW}Step 3: Optional dependencies\n${LINE}${NColor}\n"
    sleep 2
    sudo apt install libprotobuf-dev protobuf-compiler libgoogle-glog-dev \
                    libgflags-dev libgphoto2-dev libhdf5-dev \
                    doxygen
    #Eigen3
    # You can download, but you'll need create a symbolic link
    # sudo ln /usr/include/eigen3/Eigen -s /usr/include/Eigen
    pushd `pwd`
    cd /tmp/
    wget http://bitbucket.org/eigen/eigen/get/3.3.7.zip
    unzip 3.3.7.zip
    cd eigen-eigen-323c052e1731
    mkdir build
    cd build
    cmake ..
    make -j`nproc`
    sudo make install
    popd


    printf "\n\n${YELLOW}Step 4: Python3 Config\n${LINE}${NColor}\n"
    sleep 2
    #VPY=`which python3`
    #VPY=`echo ${VPY%bin/python3}lib/python3.7/site-packages/`
    pip install numpy scipy matplotlib scikit-image scikit-learn ipython
    # Cleaning cache
    rm -rfd ~/.cache/pip

    printf "\n\n${YELLOW}Step 5: Download opencv from Github\n${LINE}${NColor}\n"
    sleep 2
    mkdir $SINSTALL_PATH
    cd $WORK_FOLDER
    mkdir opencv_installation && cd opencv_installation
    # https://github.com/opencv/opencv/archive/3.4.8.zip
    # https://github.com/opencv/opencv_contrib/archive/3.4.8.zip
    git clone https://github.com/opencv/opencv.git
    git clone https://github.com/opencv/opencv_contrib.git
    cd opencv_contrib && git checkout $1
    cd ../opencv && git checkout $1
    mkdir build && cd build

    printf "\n\n${YELLOW}Step 6: Configuring\n${LINE}${NColor}\n"
    sleep 2
    cmake   \
        -ENABLE_CXX11=ON \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D WITH_TBB=ON \
        -D WITH_V4L=ON \
        -D WITH_OPENGL=ON \
        -D WITH_QT=ON \
        -D OPENCV_EXTRA_MODULES_PATH=$HOME/Downloads/opencv_contrib/modules \
        -D OPENCV_PYTHON3_INSTALL_PATH=$(echo `which python3` | sed 's/bin\/python3/lib\/python3.7\/site-packages/g') \
        -D Qt5_DIR=/usr/local/qt5 \
        -D CMAKE_PREFIX_PATH=/usr/local/qt5/5.12.6/gcc_64/lib/cmake/Qt5/ \
        ..
        
        # -DCMAKE_CXX_FLAGS=-I/usr/local/include/eigen3/ \
        # -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-3.4.8/modules \
        # -DCMAKE_INSTALL_PREFIX=${SINSTALL_PATH} \
        # -DOPENCV_PYTHON3_INSTALL_PATH=${VPY} \
        # -DQt5_DIR=${QT5_DIR} \
        # -DCMAKE_PREFIX_PATH=${QT5_DIR} \ 
        
    # For some reason, using libeigen3-dev from apt repo wasn't working
    # so, It was needed to add this flag for forcing to find Eigen3
    # It occurs 'cause some header reference
    printf "\n\n${YELLOW}Step 7: Compiling and installing\n${LINE}${NColor}\n"
    sleep 2
    make -j`nproc`
    make install
    sudo ldconfig
    echo "
#OpenCv pkg-config
export PKG_CONFIG_PATH=${SINSTALL_PATH}/lib/pkgconfig/

" >> ~/.bash_aliases

    printf "\n\n${LGREEN}OpenCv installed.\n${NColor}"
    printf "Version: `pkg-config --modversion opencv`\n"
    printf "OpenCv path: ${SINSTALL_PATH}\n"
    printf "Build dir: ${WORK_FOLDER}/opencv_installation/"
    printf "See ${LGREEN}make uninstall in build directory\n${NColor}"
    printf "\n\n${YELLOW}\033[0;36mRemember to remove repository xenial-security\n"
    printf "\n\n\n"
    popd

fi
