# intel Real Sense 深度相机

系统环境： 
- Ubuntu18.04.5 LTS aarch64
- Kernel 4.9.140-tegra
- ROS melodic 1.14.11

硬件：
- Jetson Xaiver NX / NUC / EPYC
- intel D435i & D455
----

## 驱动安装
Download tar.gz            
Github [librealsense v2.45.0](https://github.com/IntelRealSense/librealsense/releases/tag/v2.45.0)  

``` bash
cd librealsense [tab]
sudo apt update && sudo apt -y upgrade
sudo apt-get install -y git libssl-dev libusb-1.0-0-dev pkg-config libgtk-3-dev
sudo apt-get install -y libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev
sudo cp config/99-realsense-libusb.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules && udevadm trigger
mkdir build && cd build
cmake ../ -DCMAKE_BUILD_TYPE=Release -DBUILD_EXAMPLES=true
sudo make uninstall
make clean
make ##不能多核编译，会报错(应该是内存不足原因)
sudo make install
```
测试
``` bash
realsense-viewer 
```
## ROS包安装
Github: [realsense-ros](https://github.com/IntelRealSense/realsense-ros)

``` bash
mkdir -p ~/realsense_ws/src && cd ~/realsense_ws/src

git clone https://github.com/IntelRealSense/realsense-ros.git

cd ..

catkin_make

source devel/setup.bash

echo "source ~/realsense_ws/devel/setup.bash" >> ~/.bashrc
```
测试
``` bash
roslaunch realsense2_camera rs_camera.launch filters:=pointcloud

rviz
```
需要把 `Global Options` 中修改为 `/camera_link`

----


