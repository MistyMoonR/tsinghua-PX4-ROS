#!/bin/bash
 
source ~/.bashrc

sudo chmod 777 /dev/ttyUSB0

{
	gnome-terminal -t "XXD_ros" -x bash -c "roscore;exec bash"
}&
 
sleep 1s

	## --- mti-300
{
	gnome-terminal -t "mti-300-publich" -x bash -c "roslaunch xsens_mti_driver xsens_mti_node.launch;exec bash"
}&
	
	 ## --- AN Spatial

# {
# 	gnome-terminal -t "Spatial-publich" -x bash -c "rosrun advanced_navigation_driver advanced_navigation_driver;exec bash"
# }&


	## --- velodyne-16

{
	gnome-terminal -t "velodyne-publich" -x bash -c "roslaunch velodyne_pointcloud VLP16_points.launch;exec bash"
}&
 

	 ## --- leishen

# {
# 	gnome-terminal -t "XXD_cam1" -x bash -c "roslaunch lslidar_c16_decoder lslidar_c16.launch --screen;exec bash"
# }&
 
sleep 1s

	## --- RVIZ
{
	gnome-terminal -t "RVIZ" -x bash -c "rviz;exec bash"
}&
