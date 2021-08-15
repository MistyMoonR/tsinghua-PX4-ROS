# Velodyne 激光雷达

系统环境： 
- Ubuntu18.04.5 LTS aarch64
- Kernel 4.9.140-tegra
- ROS melodic 1.14.11   
      
硬件：
- Jetson Xaiver NX
- Velodyne16
  
----
可选:       
插网线, web进入后台,直接在host 部分填 `255.255.255.255` 这样同一个网段下所有设备都可以接收到来自Velodyne的数据

----

安装依懒(重要)
``` bash
sudo apt-get install ros-melodic-velodyne
```
安装驱动(需要到自己的工作空间下)
``` bash
mkdir -p ~/velodyne_ws/src && cd ~/velodyne_ws/src

git clone https://github.com/ros-drivers/velodyne.git

sudo rosdep install --from-paths src --ignore-src --rosdistro YOURDISTRO -y

cd ~/velodyne_ws/ #需要修改path

catkin_make

source devel/setup.bash

echo "source ~/velodyne_ws/devel/setup.bash" >> ~/.bashrc

```

测试
``` bash
roslaunch velodyne_pointcloud VLP16_points.launch

rosnode list

rostopic echo /velodyne_points

rosrun rviz rviz -f velodyne
```
需要把 `Global Options` 中修改为 `/velodyne`

![IMG](/pictures/Velodyne-16.png)


RVIZ
1. In the "displays" panel, click "Add", then select "Point Cloud2", then press "OK".
2. In the "Topic" field of the new "Point Cloud2" tab, enter "/velodyne_points".
3. Congratulations. Now, your Velodyne is ready to build the "real" world inside your system. Enjoy it.


----
来源：
http://wiki.ros.org/velodyne/Tutorials/Getting%20Started%20with%20the%20Velodyne%20VLP16


