#!/bin/bash

### Please fill config.cfg with your desired values before running this script

### Parsing config variables
source config.defaults 
source config.cfg 

requirements_check(){
   echo "Checking your ROS version..."
   OUTPUT=$(ls /opt/ros) && echo "${OUTPUT} version(s) identified" || (echo "No ROS detected at /opt/ros, plz download" && exit 1)
   echo "Installing script dependencies as root..."
   sudo apt-get install xmlstarlet -y
   sudo apt install xsltproc -y
   if [ $build_type == "catkin" ]
   then
     sudo apt-get install ros-${ros_distro}-catkin -y
   elif [ $build_type == "colcon" ] 
    then
      sudo apt install python3-colcon-common-extensions -y
   else 
      echo "build_type invalid, unable to download requirements."
      exit
   fi
}

checking_directory(){
   current_directory=$(pwd)
   echo ""
   echo ""
   echo ""
   echo "Please double check the following details before proceeding."
   echo "author_name: ${author_name:=$def_author_name}"
   echo "author_email: ${author_email:=$def_author_email}"
   echo "license: ${license:=$def_license}"
   echo "ros_distro: ${ros_distro:=$def_ros_distro}"
   echo "working directory: ${working_directory:=$def_working_directory}"
   echo "robot_name: ${robot_name:=$def_robot_name}"
   echo "build_type: ${build_type:=$def_build_type}"
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
   
   if [ $build_type == "catkin" ]
   then
     catkin_packages
   elif [ $build_type == "colcon" ] 
    then
    colcon_packages
   else 
      echo "build_type invalid, unable to proceed"
      exit
   fi
}


update_rootdirectory(){
   cd $working_directory && echo "Entered working directory" || (echo "Working directory error" && exit 1)
   mkdir -p $robot_name
   cd $working_directory/$robot_name
   touch README.md && echo "ROS folder for $robot_name, created by $author_name, email: $author_email " >> README.md 
}

catkin_packages(){
   #creating robot packages
   echo "creating robot metapackage" && catkin_create_pkg $robot_name --meta || (echo "catkin error" && exit 1)
   edit_metapackage
   echo "creating ${robot_name}_bringup" && catkin_create_pkg ${robot_name}_bringup || (echo "error when creating ${robot_name}_bringup package" && exit 1)
   edit_bringup
   echo "creating ${robot_name}_description" && catkin_create_pkg ${robot_name}_description || (echo "error when creating ${robot_name}_description package" && exit 1)
   echo "creating ${robot_name}_gazebo" && catkin_create_pkg ${robot_name}_gazebo || (echo "error when creating ${robot_name}_gazebo package" && exit 1)
   echo "creating ${robot_name}_navigation" && catkin_create_pkg ${robot_name}_navigation || (echo "error when creating ${robot_name}_navigation package" && exit 1)
   echo "creating ${robot_name}_slam" && catkin_create_pkg ${robot_name}_slam || (echo "error when creating ${robot_name}_slam package" && exit 1)
   echo "creating ${robot_name}_teleop" && catkin_create_pkg ${robot_name}_teleop || (echo "error when creating ${robot_name}_teleop package" && exit 1)
}

edit_metapackage(){
   cd $working_directory/$robot_name/$robot_name
   #editing package.xml file in robot_name/robot_name metapackage
   xmlstarlet ed --inplace -u "/package/description" -v "ROS packages for the ${robot_name} (metapackage)" package.xml
   xmlstarlet ed --inplace -u "/package/maintainer[@email]/@email" -v "${maintainer_email}" package.xml
   xmlstarlet ed --inplace -u "/package/maintainer[@email]" -v "${maintainer_name}" package.xml}
   xmlstarlet ed --inplace --subnode "/package" --type elem -n author -v "${author_name}" package.xml
   xmlstarlet ed --inplace --subnode "/package/author" --type attr -n email -v "${author_email}" package.xml
   xmlstarlet ed --inplace --subnode "/package" --type elem -n exec_depend -v "${robot_name}_bringup" package.xml
   xmlstarlet ed --inplace --subnode "/package" --type elem -n exec_depend -v "${robot_name}_description" package.xml
   xmlstarlet ed --inplace --subnode "/package" --type elem -n exec_depend -v "${robot_name}_gazebo" package.xml
   xmlstarlet ed --inplace --subnode "/package" --type elem -n exec_depend -v "${robot_name}_navigation" package.xml
   xmlstarlet ed --inplace --subnode "/package" --type elem -n exec_depend -v "${robot_name}_slam" package.xml
   xmlstarlet ed --inplace --subnode "/package" --type elem -n exec_depend -v "${robot_name}_teleop" package.xml
   xmlstarlet ed --inplace -u "/package/buildtool_depend" -v "${build_type}" package.xml

   #formatting to remove comments and arrange them
   xsltproc -o package.xml $current_directory/package_trf.xsl package.xml
   cd $working_directory/$robot_name
   echo "${robot_name} metapackage configured successfully."
}

edit_bringup(){
   cd $working_directory/$robot_name/${robot_name}_bringup
   xmlstarlet ed --inplace -u "/package/description" -v "roslaunch scripts for starting the physical ${robot_name}" package.xml
   xmlstarlet ed --inplace -u "/package/maintainer[@email]" -v "${maintainer_name}" package.xml}
   xmlstarlet ed --inplace -u "/package/maintainer[@email]/@email" -v "${maintainer_email}" package.xml
   xmlstarlet ed --inplace --subnode "/package" --type elem -n author -v "${author_name}" package.xml
   xmlstarlet ed --inplace --subnode "/package/author" --type attr -n email -v "${author_email}" package.xml
   xmlstarlet ed --inplace --subnode "/package" --type elem -n depend -v "roscpp" package.xml
   xmlstarlet ed --inplace --subnode "/package" --type elem -n exec_depend -v "roboteq_diff_driver" package.xml
   xmlstarlet ed --inplace --subnode "/package" --type elem -n exec_depend -v "ira_laser_tools" package.xml
}


colcon_packages(){
      echo "in development"
      exit 1
}

requirements_check
checking_directory
