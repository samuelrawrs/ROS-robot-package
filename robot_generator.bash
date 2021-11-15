#!/bin/bash

### Please fill config.cfg with your desired values before running this script

### Parsing config variables
source config.cfg 

checking_directory(){
   echo "Please double check the following details before proceeding."
   echo "your_name: ${your_name:=Jane Doe}"
   echo "your_email: ${your_email:=user@todo.todo}"
   echo "license: ${license:=BSD}"
   echo "ros_distro: ${ros_distro:=noetic}"
   echo "working directory: ${working_directory:=~}"
   echo "robot_name: ${robot_name:=robot_0}"
   echo "build_type: ${build_type:=catkin}"
   select yn in "Yes" "No"; do
    case $yn in
        Yes ) script exit;;
        No ) exit;;
    esac
   done
}

script(){
   source /opt/ros/$ros_distro/setup.bash
   update_rootdirectory
   
   if [$build_type=="catkin"]
   then
     catkin_packages
   elif [$build_type=="colcon"] #todo
    then
    colcon_packages
   else 
      echo "build_type invalid, unable to proceed"
      exit
   fi



   mkdir -p ${robot_name}/${robot_name}_bringup
   mkdir -p ${robot_name}/${robot_name}_description
   mkdir -p ${robot_name}/${robot_name}_navigation
   mkdir -p ${robot_name}/${robot_name}_slam
   mkdir -p ${robot_name}/${robot_name}_teleop


update_rootdirectory(){
cd $working_directory
   mkdir -p $robot_name
   cd $robot_name
   touch README.md && echo "ROS folder for $robot_name, created by $your_name, email: $your_email " >> README.md 
}

catkin_packages(){
 echo "creating catkin packages..."
      catkin_create_pkg $robot_name --meta
      cd $robot_name
      xmlstarlet ed --inplace -u "/package/description" -v "ROS packages for the ${robot_name} (metapackage)" package.xml
      xmlstarlet ed --inplace -u "/package/maintainer[@email]/@email" -v "${your_email}" package.xml
      xmlstarlet ed --inplace -u "/package/maintainer[@email]" -v "${your_name}" package.xml}
      xmlstarlet ed --inplace --subnode "/package" --type elem -n author -v "${your_name}" package.xml
      xmlstarlet ed --inplace --subnode "/package/author" --type attr -n email -v "${your_email}" package.xml
colcon_packages(){
      echo "in development"
      exit 
}


checking_directory
