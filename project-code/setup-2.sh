sudo sh /home/student/project/fa18-516-17/project-code/setup-2.sh

#Install Java
# Create directory and navigate to it

mkdir -p ~/cloudmesh/bin
cd ~/cloudmesh/bin

# Get file and sign user agreement
wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x64.tar.gz"

# Run Java Tarball
tar -xzvf jdk-8u191-linux-x64.tar.gz

# Install hadoop

wget http://mirrors.sonic.net/apache/hadoop/common/hadoop-3.1.1/hadoop-3.1.1.tar.gz

# Run hadoop tarball
tar -xzvf hadoop-3.1.1.tar.gz

#Update export paths for current and future installs
#Made bigger changes here - more code in original

sudo cat /home/student/project/fa18-516-17/project-code/envvar.txt >>  ~/.bashrc

source ~/.bashrc
java -version

"""If you have installed things properly there will be no errors. It will show the version as follows,
java version "1.8.0_191"
Java(TM) SE Runtime Environment (build 1.8.0_191-b12)
Java HotSpot(TM) 64-Bit Server VM (build 25.191-b12, mixed mode)
"""

#Verify the hadoop installation:

hadoop

# getting the retail data file

cd ~
curl -L "https://drive.google.com/uc?export=download&id=150QG8juv9Vo29lkJIqhMLVQmLsIjXKzJ" >retaildata2.txt


#Get to the right directory
cd /home/hduser/cloudmesh/bin/hadoop-3.1.1/sbin/

#Format the name node
hadoop namenode -format

./start-all.sh  

cd ~/cloudmesh
hdfs dfs -mkdir retailhdfs

# copy the file in using HDFS
hdfs dfs -put /home/hduser/retaildata2.txt retailhdfs

#check to make sure the retaildata2.txt file makes it to the cloudmesh/retailhdfs folder in under the hdfs system
hdfs dfs -ls retailhdfs

# HIVE
# Note the export paths have already been included in the bashrc earlier

# Get Hive
# From cloudmesh directory:
wget http://apache.claz.org/hive/hive-3.1.1/apache-hive-3.1.1-bin.tar.gz

#Extracting hive
tar -xvzf apache-hive-3.1.1-bin.tar.gz

#double check if Hive home is there
echo $HIVE_HOME 

sudo cp /home/student/project/fa18-516-17/project-code/hive-env.sh /home/hduser/cloudmesh/bin/hadoop-3.1.1

cd ~/cloudmesh

hdfs dfs -mkdir tmp


hdfs dfs -chmod g+w retailhdfs
hdfs dfs -chmod g+w tmp


#Check hive version
hive --version



#Step 8: Create hive-site.xml not sure how to edit this… many references to the DB

# I made several changes here - more code in original
sudo cp /home/student/project/fa18-516-17/project-code/hive-site.xml ~/cloudmesh/apache-hive-3.1.1-bin/conf

#save the hive-site.xml

# Derby is built into HIVE - works the purposes of this project on a local machine

~/cloudmesh/apache-hive-3.1.1-bin/bin/schematool -initSchema -dbType derby


#from here ~/cloudmesh
cd ~/cloudmesh
hive