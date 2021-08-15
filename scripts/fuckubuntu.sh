#!/bin/bash

sudo apt-get install ros-melodic-velodyne

mkdir -p ~/velodyne_ws/src && cd ~/velodyne_ws/src

git clone https://github.com/ros-drivers/velodyne.git

sudo rosdep install --from-paths src --ignore-src --rosdistro YOURDISTRO -y

cd ~/velodyne_ws/ #需要修改path

catkin_make

source devel/setup.bash

echo "source ~/velodyne_ws/devel/setup.bash" >> ~/.bashrc

