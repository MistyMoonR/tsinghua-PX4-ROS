#!/bin/bash

wget -O ~/Downloads/gtsam.zip https://github.com/borglab/gtsam/archive/4.0.2.zip

cd ~/Downloads/ && unzip gtsam.zip -d ~/Downloads/

cd ~/Downloads/gtsam-4.0.2/

mkdir build && cd build

cmake -DGTSAM_BUILD_WITH_MARCH_NATIVE=OFF ..

sudo make install -j8

mkdir -p ~/LIO-SAM_ws/src && cd ~/LIO-SAM_ws/src

git clone https://github.com/TixiaoShan/LIO-SAM.git

cd ~/LIO-SAM_ws

catkin_make

source devel/setup.bash

echo "source ~/LIO-SAM_ws/devel/setup.bash" >> ~/.bashrc

source ~/.bashrc


echo
/bin/echo -e "\e[1;36m !------------------------------------------------------------!\e[0m"
/bin/echo -e "\e[1;36m ! gtsam 和 lio_sam_ws 安装完成                                 !\e[0m"
/bin/echo -e "\e[1;36m ! 测试: roslaunch lio_sam run.launch                          !\e[0m"
/bin/echo -e "\e[1;36m ! sudo cp /usr/local/lib/libmetis.so /opt/ros/melodic/lib    !\e[0m"
/bin/echo -e "\e[1;36m !------------------------------------------------------------!\e[0m"
echo