#!/bin/bash
#build catkin_ws in home directory
#created by liuguiyu

#make dir 
sudo apt install catkin
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/src

#init catkin_ws 
catkin_init_workspace
cd ~/catkin_ws/
catkin_make

#managing your environment
echo "source $(pwd)/devel/setup.bash" >> ~/.bashrc
source ~/.bashrc

