# SLAM

系统环境： 
- Ubuntu18.04.5 LTS x86_64 
- Kernel: 5.4.0-80-generic
- ROS melodic 1.14.11

硬件：
- NUC8 i7-8650U & NUC10 i7-10710U
- 镭神激光雷达 C16
- Xsens Mti-300
- 路由器: AR750S
- 飞控: PX4
----

先决条件: `ROS` + `gtsam` + `lslidar_ws` + `xsens_ws`

# LIO-SAM 整个环境安装
来源: https://github.com/TixiaoShan/LIO-SAM

> 已经提供安装脚本 [LIO-SAM_ws-install.sh](../scripts/dev/LIO-SAM_ws-install.sh)    
> `gtsam` + `LIO-SAM_ws`
## gstam安装
```bash
wget -O ~/Downloads/gtsam.zip https://github.com/borglab/gtsam/archive/4.0.2.zip

cd ~/Downloads/ && unzip gtsam.zip -d ~/Downloads/

cd ~/Downloads/gtsam-4.0.2/

mkdir build && cd build

cmake -DGTSAM_BUILD_WITH_MARCH_NATIVE=OFF ..

sudo make install -j8
```

## LIO-SAM 工作空间安装
```bash
mkdir -p ~/LIO-SAM_ws/src && cd ~/LIO-SAM_ws/src

git clone https://github.com/TixiaoShan/LIO-SAM.git

cd ~/LIO-SAM_ws

catkin_make

source devel/setup.bash

echo "source ~/LIO-SAM_ws/devel/setup.bash" >> ~/.bashrc
```

### lio slam测试

运行指令:
```
roslaunch lio_sam run.launch
```
><font color='red'> 搬到NUC10上测试发现lio_sam_imuPreintegration问题 </font>

解决方案: https://githubmemory.com/repo/TixiaoShan/LIO-SAM/issues/247

``` bash
#纯手敲，建议自行tab补全
sudo cp /usr/local/lib/libmetis.so /opt/ros/melodic/lib
```
PS: 这个地方贼迷惑，编译要/usr，跑起来要/opt

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




## 镭神激光雷达包
来源： https://github.com/tianb03/lslidar_c16   
阅读文档: [Velodyne激光雷达ROS](../data/Velodyne_16.md)

测试：  

``` bash
roslaunch lslidar_c16_decoder lslidar_c16.launch --screen    
```
需要把 `Global Options` 中修改为 `/laser_link`

换用镭神发现NaN问题:    
><font color='red'> point cloud is not in dense format please remove nan points first </font>    

可能的解决方案：

https://www.gitmemory.com/issue/TixiaoShan/LIO-SAM/175/750888945    
https://zhuanlan.zhihu.com/p/326400722

基本要求加`removeNaNFromPointCloud` 这个方法    
但是在lio-sam的`imageProjection.cpp`中加上编译不通过。

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


