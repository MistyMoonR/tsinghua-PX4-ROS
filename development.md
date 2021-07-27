# SLAM

系统环境： 
- Ubuntu18.04 LTS
- ROS melodic 1.14.11

硬件：
- NUC10
- Advanced Navigation Spatial + Tallysman GPS
- 镭神激光雷达 C16
----

* [velodyne(可选)](data/Velodyne_16.md)
* [lslidar_c16](data/lslidar_c16.md)
* [advanced_navigation_driver](data/Spatial.md)

问题：
- [x] - 



## NUC10

新到手两台NUC10 i7      
记录一下问题：
1. ubuntu18.04 网卡没驱动，看了下要更新内核。我先试一下骚操作 ：怼USB免驱网卡 直接点software update软件让它自己更新去，更新好后重启就有了

----
## 构建自己的ws (Velodyne16 + mti-300)
`vm_ws`

进行之前的要先安装mti300 xses驱动 [地址](data/MTi-300.md) 
**未完成**
``` bash
mkdir -p ~/vm_ws/src && cd ~/vm_ws/src

git clone https://github.com/ros-drivers/velodyne.git

rosdep install --from-paths src --ignore-src --rosdistro YOURDISTRO -

cp -R /usr/local/xsens/xsens_ros_mti_driver ./

cd ..

pushd src/xsens_ros_mti_driver/lib/xspublic && make && popd

catkin_make

source devel/setup.bash

echo "source ~/vm_ws/devel/setup.bash" >> ~/.bashrc

```

----
脚本问题解决
``` bash
sed -i "s/\r//" xxx.sh
```

下载 + 编译
``` bash
git clone xxxx

cd  #到~/home下
mkdir -p ROS_ws/src
cd ROS_ws/src
catkin_init_workspace
mv xxxx #把code里面的src拷贝过去
cd ..
catkin_make
```

----
IMU 可视化 测试工具: 
https://github.com/ccny-ros-pkg/imu_tools

``` bash
mkdir -p ~/imu_tools_ws/src && cd ~/imu_tools_ws/src

git clone https://github.com/ccny-ros-pkg/imu_tools.git

cd ..

##编译前 注释 PLUGINLIB_DECLARE_CLASS

catkin_make

source devel/setup.bash

echo "source ~/imu_tools_ws/devel/setup.bash" >> ~/.bashrc
``` 

----

## rosbag的用法
https://www.jianshu.com/p/6dd2c08d688e      



| 命令       | 作用                                                  |
| :--------- | :---------------------------------------------------- |
| check      | 确定一个包是否可以在当前系统中进行,或者是否可以迁移。 |
| decompress | 压缩一个或多个包文件。                                |
| filter     | 解压一个或多个包文件。                                |
| fix        | 在包文件中修复消息,以便在当前系统中播放。             |
| help       | 获取相关命令指示帮助信息                              |
| info       | 总结一个或多个包文件的内容。                          |
| play       | 以一种时间同步的方式回放一个或多个包文件的内容。      |
| record     | 用指定主题的内容记录一个包文件。                      |
| reindex    | 重新索引一个或多个包文件。                            |


| 命令            | 作用                 |
| :-------------- | :------------------- |
| -r              | 速率                 |
| -l              | 循环loop             |
| --topic /topic1 | 只播放选择topic      |
| --pause         | 开始暂停,空格恢复    |
| -a              | record 记录所有topic |



----



[Velodyne激光雷达ROS](../data/Velodyne_16.md)(可选)
  
----

## 首先需要安装环境 (重要)

[开发环境 安装 步骤](../Development-environment.md) 

----

## 镭神激光雷达包
来源： https://github.com/tianb03/lslidar_c16

测试：  

``` bash
roslaunch lslidar_c16_decoder lslidar_c16.launch --screen    
```
需要把 `Global Options` 中修改为 `/laser_link`

![IMG](pictures/lslidar_c16_7.13.png)

----

## 九轴IMU - Spatial:     
Official website: [Spatial](https://www.advancednavigation.com/products/spatial)        
ROS wiki: [advanced_navigation_driver](http://wiki.ros.org/advanced_navigation_driver) 

ROS:         
http://wiki.ros.org/advanced_navigation_driver  (CPU占用过高)  
https://github.com/kylerlaird/advanced_navigation_driver (编译不通过)  

测试: 
``` bash
rosrun advanced_navigation_driver advanced_navigation_driver
``` 
[`Advanced Navigation ROS Driver Notes.txt`](code/ROS_ws/src/unitree_ros/advanced_navigation_driver/Advanced-Navigation-ROS-Driver-Notes.txt) 在 `/ROS_ws/src/unitree_ros/advanced_navigation_driver` 里面有详细介绍


**Advanced Navigation 提供的JAR工具包**

文件: [`SpatialManager-5.8.jar`](../data/Spatial/SpatialManager-5.8.jar)
``` bash
sudo java -jar SpatialManager-5.8.jar 
``` 

![IMG](pictures/spatial.png)

----
# IMU的坐标变换 TF
看起来应该要依附某种东西比如激光雷达身上才能做一个坐标

单独IMU只能发布数据(echo)

BLOG: [32线镭神雷达跑LeGO-LOAM：3D 激光SLAM](https://blog.csdn.net/weixin_44208916/article/details/106094490)

