# PX/PX4-Avoidance

记录PX4

----
# Obstacle Detection and Avoidance

----
## 传送门

https://github.com/PX4/PX4-Avoidance

----
PX4官网文档简直了, 先决条件Firmware应该先放前面装完

## Run the Avoidance Gazebo Simulation
``` bash 
cd ~

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

`~/.bashrc`

``` yml
export FIRMWARE_DIR={path_to_your_Firmware}
source $FIRMWARE_DIR/Tools/setup_gazebo.bash $FIRMWARE_DIR $FIRMWARE_DIR/build/px4_sitl_default
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$FIRMWARE_DIR
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$FIRMWARE_DIR/Tools/sitl_gazebo
``` 
``` bash
# Setup some more Gazebo-related environment variables (modify this line based on the location of the Firmware folder on your machine)
. ~/Firmware/Tools/setup_gazebo.bash ~/Firmware ~/Firmware/build/px4_sitl_default

export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:~/Firmware
``` 


虚拟机跑不通, 问题定位: http://docs.px4.io/master/en/dev_setup/dev_env_windows_vm.html
``` bash

apt-get purge python3-pip

apt-get install -y python3-pip

sudo apt install ros-melodic-mavros ros-melodic-mavros-extras

sudo apt install python-catkin-tools

#dataset
wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh

chmod +x install_geographiclib_datasets.sh

sudo ./install_geographiclib_datasets.sh

#
sudo apt install libpcl1 ros-melodic-octomap-*

#
mkdir -p ~/px4_ws/src && cd ~/px4_ws/src

git clone https://github.com/PX4/avoidance.git

catkin build -w ~/px4_ws --cmake-args -DCMAKE_BUILD_TYPE=Release

echo "source ~/px4_ws/devel/setup.bash" >> ~/.bashrc

source ~/.bashrc
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