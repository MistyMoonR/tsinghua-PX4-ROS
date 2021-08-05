# 镭神 激光雷达

系统环境： 
- Ubuntu18.04.5 LTS 
- ROS melodic 1.14.11


硬件：
- NUC8 i7-8650U 
- 镭神激光雷达 C16

----
问题： 
- [x] 使用镭神激光雷达需要把本机IP地址改成192.168.1.102 才能接收到点云信息
----

## 镭神激光雷达包
来源： https://github.com/tianb03/lslidar_c16

``` bash
mkdir -p ~/lslidar_ws/src && cd ~/lslidar_ws/src

cp -R /usr/local/xsens/xsens_ros_mti_driver ./

cd ..

catkin_make

source devel/setup.bash

echo "source ~/lslidar_ws/devel/setup.bash" >> ~/.bashrc
``` 
测试：  
``` bash
roslaunch lslidar_c16_decoder lslidar_c16.launch --screen    
```
需要把 `Global Options` 中修改为 `/laser_link`

![IMG](/pictures/lslidar_c16_7.13.png)

----
来源：
http://wiki.ros.org/velodyne/Tutorials/Getting%20Started%20with%20the%20Velodyne%20VLP16


