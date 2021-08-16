#!/bin/bash
 
roslaunch realsense2_camera rs_camera.launch filters:=pointcloud
 
sleep 1s

{
	gnome-terminal -t "Avoidance" -x bash -c "roslaunch ~/px4_ws/src/avoidance/local_planner/launch/avoidance.launch;exec bash"
}&
	
