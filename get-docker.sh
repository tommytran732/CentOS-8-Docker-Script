#!/bin/bash

output(){
    echo -e '\e[36m'$1'\e[0m';
}

preflight(){
    output "RHEL/CentOS 8 Docker Installation Script"
    output "Copyright © 2020 Thien Tran <contact@thientran.io>."
    output "Support: https://thientran.io/discord"
    output ""
}

os_detection(){
    output "Checking your operating system"
    if [ -r /etc/os-release ]; then
        lsb_dist="$(. /etc/os-release && echo "$ID")"
        dist_version="$(. /etc/os-release && echo "$VERSION_ID")"
    else
        exit 1
    fi
    
    if [ "$lsb_dist" =  "centos" ] || [ "$lsb_dist" =  "rhel" ]; then    
        if [ "$dist_version" = "8" ] || [ "$dist_version" = "8.1" ] || [ "$dist_version" = "8.2" ] ; then
            if [ "$lsb_dist" =  "rhel" ]; then
                output "Red Hat Enterprise Linux 8 Detected. Good to go."
            else
                output "CentOS 8 Detected. Good to go."
            fi
        fi
    else 
       output "Unsupported operating system. Only RHEL/CentOS 8 is supported."
       exit 1
    fi
}

install_docker(){
  dnf install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.13-3.2.el7.x86_64.rpm
  dnf install -y dnf-utils device-mapper-persistent-data lvm2
  dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
  dnf install -y docker-ce --nobest
  systemctl enable docker
  systemctl start docker
}

firewalld_fix(){
  if ! [ -x "$(command -v firewall-cmd)" ]; then
     output "Firewalld detected. Adding rules to make sure firewalld works with Docker."
     firewall-cmd --change-interface=docker0 --permanent
     firewall-cmd --zone=trusted --add-masquerade --permanent
     firewall-cmd --reload
  fi
}

preflight
os_detection
install_docker
firewalld_fix
