# SLAM

系统环境： 
- Ubuntu18.04.5 LTS x86_64 
- Kernel: 5.4.0-80-generic
- ROS melodic 1.14.11

硬件：
- NUC8 i7-8650U & NUC10 i7-10710U
- Advanced Navigation Spatial + Tallysman GPS(已经放弃: ROS包没加速度计)
- 镭神激光雷达 C16
- Xsens Mti-300
- 路由器: AR750S
- 飞控: PX4
----

传送门: 
* [velodyne](../data/Velodyne_16.md)
* [lslidar_c16](../data/lslidar_c16.md)
* [advanced_navigation_driver(弃用)](../data/Spatial.md)
* [xsens Mti-300](../data/MTi-300.md)

问题：

- [x] Spatial 九轴陀螺仪有ROS包，官方(MIT)提供的包发现CPU占用过高，Github上有另外fork，但是放到ROS_ws编译不通过，先放着(放弃)
- [x] IMU和激光雷达数据融合

----
先决条件: `ROS` + `lslidar_ws` + `xsens_ws`


## SLAM部分
来源: https://github.com/TixiaoShan/LIO-SAM

### lio slam测试

运行指令:
```
roslaunch lio_sam run.launch
```

切换lio slam用屋顶数据集测试发现多了一个rostopic 发布话题 `/imu_correct` 经过研究发现这是用于转换的数据,bag里面带上不知原因   

![IMG](/pictures/roof-dataset.png)

经过研究发现lio slam内部带一个imu参数转换 (这么贴心)

![IMG](/pictures/imu_raw-imu_correct.png)


配置文件:`LIO-SAM_ws/src/config/params.yaml`

参数如下

``` bash
  # Extrinsics (lidar -> IMU)
  extrinsicTrans: [0.0, 0.0, 0.0]
  extrinsicRot: [-1, 0, 0,
                  0, 1, 0,
                  0, 0, -1]
  extrinsicRPY: [0,  1, 0,
                 -1, 0, 0,
                  0, 0, 1]
```

搬到NUC10上测试发现lio_sam_imuPreintegration问题

解决方案: https://githubmemory.com/repo/TixiaoShan/LIO-SAM/issues/247

``` bash
#纯手敲，建议自行tab补全
sudo cp /usr/local/lib/libmetis.so /opt/ros/melodic/lib
```
PS: 这个地方贼迷惑，编译要/usr，跑起来要/opt,换句话说 两边缺一不可(感觉挺合适埋雷进去)

----

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


## 镭神激光雷达包
来源： https://github.com/tianb03/lslidar_c16

测试：  

``` bash
roslaunch lslidar_c16_decoder lslidar_c16.launch --screen    
```
需要把 `Global Options` 中修改为 `/laser_link`

![IMG](/pictures/lslidar_c16_7.13.png)

换用镭神发现NaN问题:    
><font color='red'> point cloud is not in dense format please remove nan points first </font>    

可能的解决方案：

https://www.gitmemory.com/issue/TixiaoShan/LIO-SAM/175/750888945    
https://zhuanlan.zhihu.com/p/326400722

基本要求我 加`removeNaNFromPointCloud` 这个方法，在lio-sam的`imageProjection.cpp`中加上编译不通过。

``` c
#include <pcl/filters/filter.h>
std::vector<int> indices;
pcl::removeNaNFromPointCloud(*outPoints, *outPoints, indices);
```
----
# IMU的坐标变换 TF
单独IMU只能发布数据(echo)

----
## 记录config
[`config.yaml`](config.yaml)


BLOG: [32线镭神雷达跑LeGO-LOAM：3D 激光SLAM](https://blog.csdn.net/weixin_44208916/article/details/106094490)


