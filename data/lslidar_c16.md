# 镭神 激光雷达

系统环境： 
- Ubuntu18.04.5 LTS 
- ROS melodic 1.14.11

硬件：
- NUC8 i7-8650U / NUC10 i7-10710U
- 镭神激光雷达 C16

----
问题： 
- [x] 使用镭神激光雷达需要把本机IP地址改成192.168.1.102 才能接收到点云信息
----

文档: 在doc目录下有     
传送门: [C16 产品资料](../doc/C16%20%20产品资料.pdf) [C16 产品使用手册](../doc/C16%20产品使用手册.pdf)  [C16 产品结构图](../doc/C16%20产品结构图.pdf)

## 镭神激光雷达包
来源： https://github.com/tianb03/lslidar_c16

问镭神那边要了一个ROS包 [LSLIDAR_C16_V3.0.4_200910_ROSK.tar.gz](LSLIDAR_C16_V3.0.4_200910_ROSK.tar.gz)

大概比较了下这两个, 感觉没啥区别

``` bash
mkdir -p ~/lslidar_ws/src && cd ~/lslidar_ws/src

git clone https://github.com/tianb03/lslidar_c16.git

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


备注：若修改了雷达目的端口及转速，请打开 lslidar_c16.launch 进行相应的修改配置，默认端口为 2368，转速为 10HZ 即 point_num 为 2000 点。

----
来源：
http://wiki.ros.org/velodyne/Tutorials/Getting%20Started%20with%20the%20Velodyne%20VLP16


