#!/bin/bash

sudo apt update

sudo apt -y upgrade

sudo apt-get update

sudo apt-get -y upgrade

#---------------------------------------------------#
#  ROS melodic 安装 
#---------------------------------------------------#

sudo apt install -y git

sudo apt install -y net-tools

sudo apt install -y neofetch

sudo apt install -y htop

sudo apt-get install -y openssh-server

sudo apt-get install -y terminator

sudo apt-get install -y stress

#---------------------------------------------------#
#  APP 安装 
#---------------------------------------------------#
 
cd ~/Desktop

wget https://az764295.vo.msecnd.net/stable/c3f126316369cd610563c75b1b1725e0679adfb3/code_1.58.2-1626302803_amd64.deb

sudo dpkg -i code_1.58.2-1626302803_amd64.deb

cd 

echo
/bin/echo -e "\e[1;36m !---------------------------------------------!\e[0m"
/bin/echo -e "\e[1;36m ! All Installation Completed                  !\e[0m"
/bin/echo -e "\e[1;36m ! 窗口运行 dpkg -l | grep ssh  测试             !\e[0m"
/bin/echo -e "\e[1;36m !---------------------------------------------!\e[0m"
echo
