#!/bin/bash

cd

sudo apt install -y ros-melodic-mavros ros-melodic-mavros-extras

sudo apt install -y python-catkin-tools

wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh

chmod +x install_geographiclib_datasets.sh

sudo ./install_geographiclib_datasets.sh