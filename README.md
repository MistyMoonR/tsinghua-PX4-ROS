# tsinghua-SLAM

用于记录SLAM开发过程

----
# SLAM Table


| SLAM算法 with Github                                             | Mechanism          | Appendix                                                                           |
| :--------------------------------------------------------------- | :----------------- | :--------------------------------------------------------------------------------- |
| [LIO-SAM](https://github.com/TixiaoShan/LIO-SAM)                 | CMU                | [Paper: LOAM](paper/LOAM:%20Lidar%20Odometry%20and%20Mapping%20in%20Real-time.pdf) |
| [A-LOAM](https://github.com/HKUST-Aerial-Robotics/A-LOAM)        | HKUST              |                                                                                    |
| [FAST-LIO](https://github.com/gisbi-kim/SC-A-LOAM)               | KAIST              |                                                                                    |
| [LeGO-LOAM](https://github.com/RobustFieldAutonomyLab/LeGO-LOAM) | Stevens            | [知乎: LeGO-LOAM分析](https://zhuanlan.zhihu.com/p/382460472)                      |
| [SC-LeGO-LOAM](https://github.com/irapkaist/SC-LeGO-LOAM)        | KAIST              | [Github: 中文注释](https://github.com/wykxwyc/LeGO-LOAM_NOTED)                     |
| [XCHU-SLAM](https://github.com/JokerJohn/xchu_slam)              | Beihang University | [知乎: 轻量级的3D激光SLAM系统](https://zhuanlan.zhihu.com/p/374933500)             |
| [LOAM-LIVOX](https://github.com/hku-mars/loam_livox)             | HKU                |                                                                                    |
| [RPG-SVO-PRO-OPEN](https://github.com/uzh-rpg/rpg_svo_pro_open)  | UZH                |                                                                                    |
     
----

## 数据集下载: 
[Visual Odometry / SLAM Evaluation 2012](http://www.cvlibs.net/datasets/kitti/eval_odometry.php)

## 数据集使用:
Github: [file_player_mulran](https://github.com/irapkaist/file_player_mulran)    
Youtube: [How to run MulRan ROS file player](https://www.youtube.com/watch?v=uU-FC-GmHXA&t=45s)

----

## 硬件相关:
### intel D435i 双目摄像头相关(由于玄学问题，需要降级到v2.45.0版本):  
Github: [librealsense](https://github.com/IntelRealSense/librealsense/releases/tag/v2.45.0)      
ROS: [realsense-ros](https://github.com/IntelRealSense/realsense-ros)

### Velodyne 16线激光雷达:     
Github:  [velodyne](https://github.com/ros-drivers/velodyne.git)        
ROS wiki: [Getting Started with the Velodyne VLP16](http://wiki.ros.org/velodyne/Tutorials/Getting%20Started%20with%20the%20Velodyne%20VLP16)

### 镭神激光雷达 C16:    
Github:  [lslidar_c16](https://github.com/tianb03/lslidar_c16)      
博客: [镭神激光雷达官方驱动安装适配](https://www.jianshu.com/p/d8efdf333e98)

### 九轴IMU - Spatial:     
Official website: [Spatial](https://www.advancednavigation.com/products/spatial)        
ROS wiki: [advanced_navigation_driver](http://wiki.ros.org/advanced_navigation_driver)   


----

