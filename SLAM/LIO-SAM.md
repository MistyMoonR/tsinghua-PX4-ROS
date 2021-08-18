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


## 镭神激光雷达包
来源： https://github.com/tianb03/lslidar_c16


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


