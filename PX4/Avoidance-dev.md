# PX4-Avoidance 障碍物检测和回避

记录PX4-Avoidance 安装全过程

系统环境： 
- Ubuntu18.04.5 LTS x86_64 
- Kernel: 5.4.0-80-generic
- ROS melodic 1.14.11

硬件：
- NUC10 i7-10710U
- 飞控: pixhawk 4
- 相机: Realsense D455
- 路由器: AR750S

# Obstacle Detection and Avoidance

环境: https://docs.px4.io/master/en/dev_setup/dev_env_linux_ubuntu.html

Github: https://github.com/PX4/PX4-Avoidance

MAVROS: https://docs.px4.io/master/en/ros/mavros_installation.html

## Installation / 环境配置

这部分可以忽略(如果运行Autopilot的话)
``` bash 
# 和https://github.com/PX4/PX4-Autopilot.git 就是一个东西
git clone https://github.com/PX4/Firmware.git --recursive

cd /Firmware

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

## 数据集下载
``` bash

sudo apt install -y ros-melodic-mavros ros-melodic-mavros-extras

sudo apt install -y python-catkin-tools

#dataset
wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh

chmod +x install_geographiclib_datasets.sh

sudo ./install_geographiclib_datasets.sh
``` 

脚本跑不了一般是网站问题, 需要手动网站下载      
为了方便我把 `/usr/share/GeographicLib`下面需要的东西放到 [Data](../data/GeographicLib)去      
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

``` bash
export FIRMWARE_DIR=~/Firmware
source $FIRMWARE_DIR/Tools/setup_gazebo.bash $FIRMWARE_DIR $FIRMWARE_DIR/build/px4_sitl_default
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$FIRMWARE_DIR
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$FIRMWARE_DIR/Tools/sitl_gazebo
source ~/px4_ws/devel/setup.bash
``` 

`~/px4_ws/devel/setup.bash`

``` bash
. /home/ros/Firmware/Tools/setup_gazebo.bash /home/ros/Firmware /home/ros/Firmware/build/px4_sitl_default
export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:~/Firmware
export GAZEBO_MODEL_PATH=${GAZEBO_MODEL_PATH}:/home/ros/px4_ws/src/avoidance/avoidance/sim/models
``` 
测试

运行 [QGroundControl](../data/QGroundControl.AppImage)    
下载地址: http://qgroundcontrol.com/

``` bash
./QGroundControl.AppImage
``` 

局部规划测试: (gazebo)
``` bash
roslaunch local_planner local_planner_stereo.launch
``` 
## NUC10上运行 

实际机器测试: 需要先跑一边脚本 `tools\generate_launchfile.sh.deprecated`    
(不懂为何deprecated)

会在`local_planner`地址下面生成一个`avoidance.launch`文件, 不过的需要一个`px4_config.ymal` 从`avoidance\resource`那边复制了一个过来
      

```bash
cd ~\px4_ws\src\avoidance
# 官方没说明为何废弃
bash tools\generate_launchfile.sh.deprecated
```
进去修改一下, 参考下面`avoidance.launch`

## PX4飞控配置

来源: https://docs.px4.io/master/en/companion_computer/pixhawk_companion.html     

QGC进去修改参数:        
**MAV_1_CONFIG** = `TELEM 2`        
**MAV_1_MODE** = `Onboard`        
**SER_TEL2_BAUD** = `921600`      

然后把制作好的串口线插到`TELEM 2`接口

查找ttyUSB    
```bash
ls -l /dev/ttyUSB*
```

测试`mavros`
```bash
#本机测试
roslaunch mavros px4.launch fcu_url:=/dev/ttyUSB0:921600 gcs_url:=udp://@127.0.0.1:14550
```
然后本机器运行QGC, 不出意外的话会显示connected

>**问题**       
> - CH340没法启动mavros       
> 解决办法: 更改波特率or换ft2302        
> 
> - RTT too high for timesync 延迟过大       
> 解决办法: PX4和NUC时区不同导致, 更改NUC上面时区为UTC + 0 然后重启解决

## 运行avoidance
不过需要写个脚本分别运行相机和avoidance避障

``` bash
roslaunch realsense2_camera rs_camera.launch filters:=pointcloud

cd ~\px4_ws\src\avoidance\local_planner\launch

roslaunch avoidance.launch
```
----

## `avoidance.launch` 记录

``` xml
<launch>
    <arg name="ns" default="/"/>
    <arg name="fcu_url" default="/dev/ttyUSB0:921600"/>    
    <!-- <arg name="gcs_url" default="udp://@127.0.0.1:14550" />    -->
    <!-- GCS link is provided by SITL -->
    <arg name="tgt_system" default="1" />
    <arg name="tgt_component" default="1" />

  <!-- Launch static transform publishers -->
  <node pkg="tf" type="static_transform_publisher" name="tf_depth_camera" args="0.15 0 -0.15 0 0 0 fcu camera_link 10"/>
  <!-- <node pkg="tf" type="static_transform_publisher" name="link1_link2_broadcaster" args="x y z yaw pitch raw link1 link2 100" /> -->

    <!-- Launch MavROS -->
    <group ns="$(arg ns)">
        <include file="$(find mavros)/launch/node.launch">
            <arg name="pluginlists_yaml" value="$(find mavros)/launch/px4_pluginlists.yaml" />
            <!-- Need to change the config file to get the tf topic and get local position in terms of local origin -->
            <arg name="config_yaml" value="$(find local_planner)/resource/px4_config.yaml" />
            <arg name="fcu_url" value="$(arg fcu_url)" />
            <arg name="gcs_url" value="$(arg gcs_url)" />
            <arg name="tgt_system" value="$(arg tgt_system)" />
            <arg name="tgt_component" value="$(arg tgt_component)" />
        </include>
    </group>

    <!-- Launch cameras -->
    <!-- <include file="$(find realsense2_camera)/launch/rs_d435_camera.launch" ></include> -->

    <!-- Launch avoidance -->
    <env name="ROSCONSOLE_CONFIG_FILE" value="$(find local_planner)/resource/custom_rosconsole.conf"/>
    <arg name="pointcloud_topics" default="[/camera/depth/color/points]"/>

    <!-- Launch local planner -->
    <node name="local_planner_node" pkg="local_planner" type="local_planner_node" output="screen" required="true" >
      <param name="goal_x_param" value="0" />
      <param name="goal_y_param" value="0"/>
      <param name="goal_z_param" value="4" />
      <rosparam param="pointcloud_topics" subst_value="True">$(arg pointcloud_topics)</rosparam>
    </node>
    
    <!-- set or toggle rqt parameters -->
    <node name="rqt_param_toggle" pkg="local_planner" type="rqt_param_toggle.sh" />

</launch>
```


----
来源:        
https://zhuanlan.zhihu.com/p/158064913      
https://docs.px4.io/master/en/computer_vision/obstacle_avoidance.html

----

## 硬件相关:
### intel D435i 双目摄像头相关:  
Github: [librealsense](https://github.com/IntelRealSense/librealsense/releases/tag/v2.45.0)      
ROS: [realsense-ros](https://github.com/IntelRealSense/realsense-ros)

----
[Paper: LOAM-L]:paper/LOAM:%20Lidar%20Odometry%20and%20Mapping%20in%20Real-time.pdf
[Paper: LVI-SAM-L]:paper/LVI-SAM.pdf
[知乎LeGO-L]:https://zhuanlan.zhihu.com/p/382460472
[BlogLeGO-L]:https://blog.csdn.net/learning_tortosie/article/details/86527542
[Github中文注释-L]:https://github.com/wykxwyc/LeGO-LOAM_NOTED
[知乎3D激光SLAM系统-L]:https://zhuanlan.zhihu.com/p/374933500
