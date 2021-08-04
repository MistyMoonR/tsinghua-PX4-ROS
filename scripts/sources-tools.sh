#!/bin/bash

#---------------------------------------------------#
#  换清华源 用于提高速度 (非大陆用户自行删除) .... 
#---------------------------------------------------#

sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

sudo rm -rf /etc/apt/sources.list

# 由于linux的feature，sudo 只对 echo起作用，没有对>>起作用。因此采用touch然后mv方法
touch ~/Desktop/sources.list

sudo echo "# 清华镜像源" >> ~/Desktop/sources.list

sudo echo "# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释" >> ~/Desktop/sources.list
sudo echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse" >> ~/Desktop/sources.list
sudo echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse" >> ~/Desktop/sources.list
sudo echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse" >> ~/Desktop/sources.list
sudo echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse" >> ~/Desktop/sources.list
sudo echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse" >> ~/Desktop/sources.list
sudo echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse" >> ~/Desktop/sources.list
sudo echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse" >> ~/Desktop/sources.list
sudo echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse" >> ~/Desktop/sources.list

sudo mv ~/Desktop/sources.list /etc/apt/

#---------------------------------------------------#
#  update 使配置生效 
#---------------------------------------------------#

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
