#!/bin/bash
mkdir ~/rosbag_data_01

cd ~/rosbag_data_01

rosbag record /lslidar_pointcloud_c16 /mavros/imu/data /mavros/gpsstatus/gps1/raw

