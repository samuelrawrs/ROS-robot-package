#!/bin/bash

### Parsing config variables
source config.cfg # load the config library functions

checking_directory(){
   echo "Please double check the following details"
   echo "working directory: ${working_directory:=~}"
   select yn in "Yes" "No"; do
    case $yn in
        Yes ) making_directories exit;;
        No ) exit;;
    esac
   done
}

# making_directories(){
#    # mkdir -p ${robot_name}/${robot_name}_bringup
#    # mkdir -p ${robot_name}/${robot_name}_description
#    # mkdir -p ${robot_name}/${robot_name}_navigation
#    # mkdir -p ${robot_name}/${robot_name}_slam
#    # mkdir -p ${robot_name}/${robot_name}_teleop
# }




checking_directory
