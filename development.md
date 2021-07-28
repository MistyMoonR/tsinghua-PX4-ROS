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
**ubuntu18.04 网卡没驱动**      
解决方法: 怼USB免驱网卡 直接点software update软件让它自己更新去，更新好后重启就有了

![IMG](pictures/nuc10.png)


nuc10 开机过快，加个grub
``` bash
sudo gedit /etc/default/grub
sudo update-grub
```
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

---
```

----

脚本问题解决
``` bash
sed -i "s/\r//" xxx.sh
```

下载 + 编译
``` bash

```

----
# IMU的坐标变换 TF
看起来应该要依附某种东西比如激光雷达身上才能做一个坐标

单独IMU只能发布数据(echo)

BLOG: [32线镭神雷达跑LeGO-LOAM：3D 激光SLAM](https://blog.csdn.net/weixin_44208916/article/details/106094490)

