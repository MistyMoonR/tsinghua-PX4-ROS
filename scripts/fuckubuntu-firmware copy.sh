#!/bin/bash

cd

git clone https://github.com/PX4/Firmware.git --recursive

cd /Firmware

./Tools/setup/ubuntu.sh --no-sim-tools --no-nuttx

sudo apt -y install gstreamer1.0-plugins-bad gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly libgstreamer-plugins-base1.0-dev

export QT_X11_NO_MITSHM=1

make px4_sitl_default gazebo


