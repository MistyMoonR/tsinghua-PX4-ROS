##
roslaunch xsens_mti_driver xsens_mti_node.launch
##
roslaunch velodyne_pointcloud VLP16_points.launch
##
cd ~/vt_data

rosbag record /points_raw /imu/data
