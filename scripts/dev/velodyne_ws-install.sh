#!/bin/bash

sudo apt-get install -y ros-melodic-velodyne

mkdir -p ~/velodyne_ws/src && cd ~/velodyne_ws/src

git clone https://github.com/ros-drivers/velodyne.git

sudo rosdep install --from-paths src --ignore-src --rosdistro YOURDISTRO -y

sudo rosdep init

sudo rosdep update

cd ~/velodyne_ws

catkin_make

source devel/setup.bash

echo "source ~/velodyne_ws/devel/setup.bash" >> ~/.bashrc

source ~/.bashrc


echo
/bin/echo -e "\e[1;36m !---------------------------------------------------------!\e[0m"
/bin/echo -e "\e[1;36m ! velodyne_ws 安装完成                                     !\e[0m"
/bin/echo -e "\e[1;36m ! 测试: roslaunch velodyne_pointcloud VLP16_points.launch  !\e[0m"
/bin/echo -e "\e[1;36m !----------------------------------------------------------!\e[0m"
echo