#!/bin/bash
 
source ~/.bashrc

sudo chmod 777 /dev/ttyUSB0

{
	gnome-terminal -t "XXD_ros" -x bash -c "roslaunch realsense2_camera rs_camera.launch filters:=pointcloud;exec bash"
}&
 
sleep 1s

cd ~/px4_ws/src/avoidance/local_planner/launch/

roslaunch avoidance.launch