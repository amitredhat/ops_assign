#!/bin/bash

##Simple script to launch an EC2
##Author:Amit Kumar
##Make Sure you have installed awscli and configured it
##This script is tested on fresh AWS Account in Asia Pacific (Mumbai) region

aws_dir="/opt/ops_assign"
pemkey="ops_key"
sg="ops_sg"
img="ami-0a574895390037a62"
itype="t2.micro"
sbnt=$(aws ec2 describe-subnets | grep SubnetId | head -n 1 | cut -d":" -f 2 | tr -d '"' | tr -d ",")
pass="password"  ##Enter your mysql password here.

##keyPair
echo "Creating Key Pair"

aws ec2 create-key-pair --key-name $pemkey --query 'KeyMaterial' --output text > $aws_dir/$pemkey.pem

echo "Key Pair is created with name $pemkey.pem at $aws_dir"; chmod 400 $aws_dir/$pemkey.pem

##SecurityGroup
echo "Creating security Group"

aws ec2 create-security-group --group-name $sg --description "$sg security group" --vpc-id $(aws ec2 describe-vpcs | grep VpcId | cut -d":" -f 2 | tr -d '"' | tr -d ",") > $aws_dir/$sg.txt

for sgd in $aws_dir/$sg.txt
    do 
    sgid=$(cat $aws_dir/$sg.txt | grep GroupId | cut -d":" -f 2 | tr -d '"' )
    echo "Security Group id is $sgid"
    aws ec2 authorize-security-group-ingress --group-id $sgid --protocol tcp --port 22 --cidr 0.0.0.0/0
    aws ec2 authorize-security-group-ingress --group-id $sgid --protocol tcp --port 8080 --cidr 0.0.0.0/0
    rm -rf $aws_dir/$sg.txt
    echo "security group created with name $sg , port 22 & 8080 are opened for 0.0.0.0/0"
    done;

##Create EC2 instance with Ubuntu AMI
echo "Lauching an EC2"
aws ec2 run-instances --image-id $img --count 1 --instance-type $itype --key-name $pemkey --security-group-ids $sgid --subnet-id $sbnt > $aws_dir/ec2.txt

for ins_details in  $aws_dir/ec2.txt
    do
    i_id=$(cat $ins_details | grep InstanceId| cut -d":" -f 2 | tr -d '"' | tr -d ",")
    echo "Instance id is $i_id"
    sleep 5
    pub_ip=$(aws ec2 describe-instances --instance-ids $i_id | grep PublicIpAddress | cut -d":" -f 2 | tr -d '"' | tr -d "," | tr -d " ")
    rm -rf $ins_details 
    done;

echo "installing packages on remote machine, Wait few seconds while system is coming up"
sleep 25
ssh -i $aws_dir/$pemkey.pem -o "StrictHostKeyChecking=no" ubuntu@$pub_ip 'bash -s' <  $aws_dir/soft_install.sh

    echo "EC2 instance is launched with required software, Public IP Address of instance is $pub_ip"
    echo "EC2 public ip is $pub_ip"
    echo "Mysql root password is $pass"


