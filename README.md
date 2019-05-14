# ops_assign

It have two shell script that will perform below activity.

- Infra Creation Stage: Create EC2 instance (using AWS CLI)
- Software Configuration Stage: Configure Required Packages for Tomcat & MySQL
- Application Build Stage: Build Java Application (Use maven as Build Tool)
- Application Deploy Stage: Deploy Java Application 

# Prerequisite

- Make Sure you have installed awscli and configured it
- This script is tested on fresh AWS Account in Asia Pacific (Mumbai) region
- Jenkins installe and configure with suggested plugins along with "Deploy to container"
- Configure tomcat manager which will be used in Jenkins to deploy build.

# In order to launch EC2 and Configure required software, Run script as below.

- cd /opt
- git clone https://github.com/amitredhat/ops_assign.git
- cd ops_assign
- /bin/bash aws_ec2.sh

# Import jenkins jobs using below command.
- java -jar jenkins-cli.jar -s http://jenkins_host:8080/ create-job  ops_assign < ops_assign.xml

Please note: Change your tomcat host and manager credentials accordingly.


