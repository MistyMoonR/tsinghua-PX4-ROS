# PX/PX4-Autopilot

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

构建px4_ws

* [velodyne(可选)](../data/Velodyne_16.md)
* [lslidar_c16](../data/lslidar_c16.md)
* [advanced_navigation_driver](../data/Spatial.md)

问题：
- [x] -

大概过程:  `ubuntu.sh` -> `ubuntu_sim_ros_melodic.sh` -> `PX4-Autopilot.git`

----
## 环境配置note

运行 前可能需要切换python3版本, 查看方式 `python -V`
``` bash
sudo update-alternatives --install /usr/bin/python python /usr/bin/python2 100
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 150
``` 


## Ubuntu Setup
来源: https://docs.px4.io/master/en/dev_setup/dev_env_linux_ubuntu.html     


``` bash 
git clone https://github.com/PX4/PX4-Autopilot.git --recursive

# Run the ubuntu.sh with no arguments (in a bash shell) to install everything
bash ./PX4-Autopilot/Tools/setup/ubuntu.sh
``` 
**完成后要重启**

安装: ROS/Gazebo

``` bash 
wget https://raw.githubusercontent.com/PX4/Devguide/master/build_scripts/ubuntu_sim_ros_melodic.sh

bash ubuntu_sim_ros_melodic.sh
``` 
不出意外的话这里步骤会把 PX4-Autopilot的ROS 工作空间编译通过


进入PX4源码目录，编译
``` bash 
cd ~/PX4-Autopilot [tab]
# Jmavsim
make px4_sitl jmavsim
# Gazebo
make px4_sitl gazebo
``` 
进入PX4源码目录，测试roslaunch
``` bash 
source Tools/setup_gazebo.bash $(pwd) $(pwd)/build/px4_sitl_default
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$(pwd):$(pwd)/Tools/sitl_gazebo

roslaunch px4 multi_uav_mavros_sitl.launch
``` 


## ROS with MAVROS Installation Guide
来源: https://docs.px4.io/master/en/ros/mavros_installation.html

### ROS repository
``` bash 
sudo apt-get install ros-melodic-mavros ros-melodic-mavros-extras
``` 
### GeographicLib: 由于网站问题, 不一定好用, 需要手动copy
``` bash 
wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh
sudo bash ./install_geographiclib_datasets.sh 
``` 
### Source Installation
``` bash 
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws
catkin init
wstool init src
``` 

``` bash 
wstool init ~/catkin_ws/src
``` 

1. Install MAVLink: 已经修改成 melodic
    ``` bash 
    rosinstall_generator --rosdistro melodic mavlink | tee /tmp/mavros.rosinstall
    ``` 
2. MAVROS Released/stable
    ``` bash
    rosinstall_generator --upstream mavros | tee -a /tmp/mavros.rosinstall
    ``` 
3. Create workspace & deps
    ``` bash
    wstool merge -t src /tmp/mavros.rosinstall
    wstool update -t src -j4
    rosdep install --from-paths src --ignore-src -y
    ``` 
4. GeographicLib datasets
    ``` bash
    ./src/mavros/mavros/scripts/install_geographiclib_datasets.sh
    ``` 
5. Build source
    ``` bash
    catkin build
    ``` 
6. setup.bash
    ``` bash
    source devel/setup.bash
    ``` 



测试

``` bash

``` 

----

来源:        

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