#!/bin/bash   
###################################################################################
#	Author: H.M. Shah Paran Ali
#	OS Environment: Linux
#	Description: This script will be used to convert JDK from one version to another
#	Email: paran.duet@gmail.com
###################################################################################

###### JDK Installation Process
echo "Welcome to Java Installation System"
read -p "Enter your souce directory : " source_path
read -p "Enter your JDK Version : " jdk_version
JAVA_DIR=/usr/java/
JDK_DIR=jdk$jdk_version
	if [ ! -d "$JAVA_DIR" ]; then
		mkdir /usr/java
		yes|cp -R $source_path/* $JAVA_DIR/$JDK_DIR/
	fi
	
	alternatives --install /usr/bin/java java /usr/java/$JDK_DIR/bin/java 100
	
	alternatives --config java

echo "######## Change By Paran" >> /root/.bashrc
echo "JAVA_HOME=/usr/java/$JDK_DIR" >> /root/.bashrc
echo "PATH=$PATH:"'$JAVA_HOME/bin' >> /root/.bashrc

echo "######## Change By Paran" >> /root/.bash_profile
echo "JAVA_HOME=/usr/java/$JDK_DIR" >> /root/.bash_profile
echo "PATH=$PATH:"'$HOME/bin:$JAVA_HOME/bin' >> /root/.bash_profile

echo "export PATH" >> /root/.bash_profile
export "JAVA_HOME" >> /root/.bash_profile

echo "######## Change By Paran" >> /etc/bashrc
echo "export JAVA_HOME=/usr/java/$JDK_DIR/" >> /etc/bashrc
echo "export PATH="'$PATH:/usr/java/'"$JDK_DIR/bin/"  >> /etc/bashrc

echo "######## Change By Paran" >> /etc/profile
echo "export JAVA_HOME=/usr/java/$JDK_DIR/" >> /etc/profile
echo "export PATH="'$PATH:/usr/java/'"$JDK_DIR/bin/"

echo "Please check your JDK version and corresponding path"
java -version
which java
which java	