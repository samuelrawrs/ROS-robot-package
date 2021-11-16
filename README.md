# ROS/RMF Robot File Generator
author/maintainer: [samuel](https://github.com/samuelrawrs)

## Rationale
Robots in ROS tend to follow similar folder structures (packages). However, these files tend to be created manually and there's a lot of manual editing of `package.xml` and `CMakeLists.txt`. This script was created to streamline this process as much as possible. However, even tho the basic structure is created, there is a need to **update** the aforementioned files if you add new dependencies, etc. Feel free to add your own packages for your own needs.

## Requirements (will be checked in script)
1. This script was developed on Ubuntu 20.04, mainly using ROS noetic and catkin.

2. The editing of `package.xml` is done thru XML starlet and xsltproc:  
```
sudo apt-get update
sudo apt-get install xmlstarlet
sudo apt install xsltproc
```

3. This script assumes you have ROS installed in `/opt/ros/` folder and **catkin** or **colcon** installed which comes by default. If it's missing:   

install catkin (replace noetic with your distro): 
```
sudo apt-get install ros-noetic-catkin
```  
install colcon:
```
sudo apt install python3-colcon-common-extensions
```



## Instructions
1. Go into `config.cfg` and edit the values to what you want (name of robot, your name, etc.)
2. Go to terminal and run `bash robot_generator.bash` and follow the prompts

## Updates
- 15/11/2021 Trying to develop for both catkin (ROS1) and colcon (ROS2), will update when they're tested and builds without issue

## To-do
- Create support for more than 1 maintainer


## Credits
This script is mainly influenced by multiple open-sourced robots such as [turtlebot3](https://github.com/ROBOTIS-GIT/turtlebot3) and [husky](https://github.com/husky/husky) which share these similar file structures.