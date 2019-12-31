#!/bin/bash

output(){
    echo -e '\e[36m'$1'\e[0m';
}

preflight(){
    output "Simple CentOS 8 Docker Installation Script"
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
    
    if [ "$lsb_dist" =  "centos" ] || [ "$dist_version" = "8" ]; then
       output "CentOS 8 Detected. Good to go."
    else 
       output "Unsupported operating system. Only CentOS 8 is supported."
       exit 1
    fi
}

install_docker(){
  dnf install -y dnf-utils device-mapper-persistent-data lvm2
  dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
  dnf install -y docker-ce --nobest
  systemctl enable docker
  systemctl start docker
}

os_detection
install_docker
