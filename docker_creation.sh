#!/bin/bash

if [[ ( $@ == "--help") ||  $@ == "-h" ]]
then 
	echo "Usage: $0 [IMAGE_NAME] [CONTAINER_NAME] [DEVEL FOLDER]"
	exit 0
fi 

if [[ ($# -eq 0 ) ]]
then
	echo "No arguments specified, using wizard mode"
	
	echo "Insert the absolute path of the dev folder [~/dev]"
	read dev_folder
	if [[ ($dev_folder -eq "") ]]
	then 
		dev_folder="/home/$USER/dev"
	fi
	if [ ! -d $dev_folder ] 
	then
		echo "[WARNING] devel folder doesn't exists, creating a new one"
		mkdir /home/$USER/dev
		#exit 0
	fi
	echo dev folder: $dev_folder
	
	echo "Insert the name image for the container or select an image"
	echo "1 - ROS1 image"
	echo "2 - ROS2 image"
	echo "3 - PX4 stack with ROS1 and ROS2"
	echo "4 - Robotics Lab ROS1"
	echo "5 - ROS1 - RTABMAP"
	echo "6 - ROS - melodic - KIMERA"
	echo "7 - ROS - melodic"
	echo "8 - PDT - ws"
	echo "9 - Ubuntu 18.04"
	
	read in
	if [[ ($in -eq "1") ]]
	then
		echo "Selected ROS1 image"
		im_name=osrf/ros:noetic-desktop		
	elif [[ ($in -eq "2") ]]
	then
			echo "Selected ROS2 image"
			im_name=osrf/ros:humble-desktop
	elif [[ ($in -eq "3") ]]
	then
			echo "Selected PX4 control stack with ROS1 and ROS2"
			im_name=px4io/px4-dev-ros2-foxy
	elif [[ ($in -eq "4") ]]
	then
			echo "Selected Robotics Lab ROS1 image"
			im_name=jocacace/rl_ros1
	elif [[ ($in -eq "5") ]]
	then
			echo "Selected ROS1 and RTABMAP image"
			im_name=introlab3it/rtabmap_ros:noetic-latest	
	elif [[ ($in -eq "6") ]]
	then
			echo "Selected ROS melodic and Kimera image"
			im_name=vinsco30/kimera-ros-melodic
	elif [[ ($in -eq "7") ]]
	then
			echo "Selected ROS melodic"
			im_name=osrf/ros:melodic-desktop
	elif [[ ($in -eq "8") ]]
	then
			echo "Selected PDT ws"
			im_name=jocacace/leo_ws
	elif [[ ($in -eq "9") ]]
	then
			echo "Selected Ubuntu18.04"
			im_name=vinsco30/orb-slam3-melodic:latest
	else
			im_name=$in
	fi
	
	echo "Image name: " $im_name
	
	
	echo "Insert the name of the container"
	read container_name
	
	
	for c in $(docker container ls -a --format '{{.Names}}')
	do
		if [ $container_name == $c ] 
		then
			echo "[ERROR] Name already used for a container, exiting"
			exit 0
		fi
	done
else
	im_name=$1
	container_name=$2
	dev_folder=$3
fi


echo -e "\n\nCreating a new container" 
echo "Docker Image ... " $im_name
echo "Container name ... " $container_name
echo "Developer folder ... " $dev_folder

##Without sharing a folder

xhost +

docker run -it --privileged -v /dev/bus/usb:/dev/bus/usb \
-v $dev_folder:/home/dev/:rw \
-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
-e DISPLAY=:0 \
--network host \
--workdir="/home/dev/" \
--name=$container_name $im_name bash



