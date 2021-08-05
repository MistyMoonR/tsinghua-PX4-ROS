# PX/PX4-Avoidance

记录PX4 安装全过程

系统环境： 
- Ubuntu18.04.5 LTS x86_64 
- Kernel: 5.4.0-80-generic
- ROS melodic 1.14.11

硬件：
- NUC8 i7-8650U & NUC10 i7-10710U
- 镭神激光雷达 C16 / Velodyne VPL-16
- Xsens Mti-300
- 路由器: AR750S
- 飞控: PX4

# Obstacle Detection and Avoidance

官方文档: 
https://docs.px4.io/master/en/dev_setup/dev_env_linux_ubuntu.html

模型: https://docs.px4.io/master/en/simulation/gazebo_vehicles.html

构建px4_ws

* [velodyne(可选)](../data/Velodyne_16.md)
* [lslidar_c16](../data/lslidar_c16.md)
* [advanced_navigation_driver](../data/Spatial.md)

问题：
- [x] 虚拟机没法测试, 比如Gebzeo 

----
## 环境配置note

来源: https://github.com/PX4/PX4-Avoidance

PX4 Github 文档简直了, 先决条件Firmware应该先放前面装完

指导: https://docs.px4.io/master/en/ros/mavros_installation.html

## Run the Avoidance Gazebo Simulation

这部分可以忽略(如果运行Autopilot的教程的话)
``` bash 
cd ~

# 和https://github.com/PX4/PX4-Autopilot.git 就是一个东西!!!!!!!!!!!!!
git clone https://github.com/PX4/Firmware.git --recursive

cd ~/Firmware

# Install PX4 "common" dependencies.
./Tools/setup/ubuntu.sh --no-sim-tools --no-nuttx

# Gstreamer plugins (for Gazebo camera)
sudo apt install gstreamer1.0-plugins-bad gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly libgstreamer-plugins-base1.0-dev

# This is necessary to prevent some Qt-related errors (feel free to try to omit it)
export QT_X11_NO_MITSHM=1

# Build and run simulation
make px4_sitl_default gazebo

# Quit the simulation (Ctrl+C)
``` 

``` bash
# Setup some more Gazebo-related environment variables (modify this line based on the location of the Firmware folder on your machine)
. ~/Firmware/Tools/setup_gazebo.bash ~/Firmware ~/Firmware/build/px4_sitl_default

export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:~/Firmware
``` 

虚拟机跑不通, 问题定位: http://docs.px4.io/master/en/dev_setup/dev_env_windows_vm.html

NUC10 已经跑通, 有诸多问题需要解决

## 数据集下载
``` bash

sudo apt install -y ros-melodic-mavros ros-melodic-mavros-extras

sudo apt install -y python-catkin-tools

#dataset
wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh

chmod +x install_geographiclib_datasets.sh

sudo ./install_geographiclib_datasets.sh
``` 
脚本跑步来一般是网站问题, 需要手动网站下载      
为了方便我把 `/usr/share/GeographicLib`下面需要的东西放到[Data](../data/GeographicLib)去      
Issues:  https://github.com/mavlink/mavros/issues/963


## 构建avoidance的工作空间

需要把环境换成python2.7
``` bash
sudo update-alternatives --config python
## 选择编号
``` 

``` bash
sudo apt install libpcl1 ros-melodic-octomap-*

mkdir -p ~/px4_ws/src && cd ~/px4_ws/src

git clone https://github.com/PX4/avoidance.git

catkin build -w ~/px4_ws --cmake-args -DCMAKE_BUILD_TYPE=Release

echo "source ~/px4_ws/devel/setup.bash" >> ~/.bashrc

source ~/.bashrc
``` 
运行不起来问题: 环境变量问题:       
Issues: https://github.com/PX4/PX4-Avoidance/issues/596

记录一下环境变量

`~/.bashrc`

``` yml
export FIRMWARE_DIR=~/Firmware
source $FIRMWARE_DIR/Tools/setup_gazebo.bash $FIRMWARE_DIR $FIRMWARE_DIR/build/px4_sitl_default
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$FIRMWARE_DIR
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$FIRMWARE_DIR/Tools/sitl_gazebo
source ~/px4_ws/devel/setup.bash
``` 

`~/px4_ws/devel/setup.bash`

``` yml
. /home/ros/Firmware/Tools/setup_gazebo.bash /home/ros/Firmware /home/ros/Firmware/build/px4_sitl_default
export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:~/Firmware
export GAZEBO_MODEL_PATH=${GAZEBO_MODEL_PATH}:/home/ros/px4_ws/src/avoidance/avoidance/sim/models
``` 
测试

先运行[APP](../data/QGroundControl.AppImage) 
``` bash
cd Desktop
./QGroundControl.AppImage
``` 

``` bash
roslaunch local_planner local_planner_stereo.launch
``` 

----

来源:        
https://zhuanlan.zhihu.com/p/158064913      
https://docs.px4.io/master/en/computer_vision/obstacle_avoidance.html

----

## 硬件相关:
### intel D435i 双目摄像头相关(由于玄学问题，需要降级到v2.45.0版本):  
Github: [librealsense](https://github.com/IntelRealSense/librealsense/releases/tag/v2.45.0)      
ROS: [realsense-ros](https://github.com/IntelRealSense/realsense-ros)

### Velodyne 16线激光雷达:     
Github:  [velodyne](https://github.com/ros-drivers/velodyne.git)        
ROS wiki: [Getting Started with the Velodyne VLP16](http://wiki.ros.org/velodyne/Tutorials/Getting%20Started%20with%20the%20Velodyne%20VLP16)

### 镭神激光雷达 C16:    
Github:  [lslidar_c16](https://github.com/tianb03/lslidar_c16)      
博客: [镭神激光雷达官方驱动安装适配](https://www.jianshu.com/p/d8efdf333e98)

### 九轴IMU - Spatial:     
Official website: [Spatial](https://www.advancednavigation.com/products/spatial)        
ROS wiki: [advanced_navigation_driver](http://wiki.ros.org/advanced_navigation_driver)   


----
[Paper: LOAM-L]:paper/LOAM:%20Lidar%20Odometry%20and%20Mapping%20in%20Real-time.pdf
[Paper: LVI-SAM-L]:paper/LVI-SAM.pdf
[知乎LeGO-L]:https://zhuanlan.zhihu.com/p/382460472
[BlogLeGO-L]:https://blog.csdn.net/learning_tortosie/article/details/86527542
[Github中文注释-L]:https://github.com/wykxwyc/LeGO-LOAM_NOTED
[知乎3D激光SLAM系统-L]:https://zhuanlan.zhihu.com/p/374933500