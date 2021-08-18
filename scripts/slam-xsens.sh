#!/bin/bash
 
{
	gnome-terminal -t "velodyne_pointcloud" -x bash -c "roslaunch velodyne_pointcloud VLP16_points.launch;exec bash"
}&


sleep 1s

{
	gnome-terminal -t "xsens_mti_driver" -x bash -c "roslaunch xsens_mti_driver xsens_mti_node.launch;exec bash"
}&
	
