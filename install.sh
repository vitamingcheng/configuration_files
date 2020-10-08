#!/bin/bash
# 1. 安装docker

echo -e "\033[42;34m----------安装docker---------- \033[0m"

## 更新yum源

yum -y update

echo -e "\033[42;34m 更新yum源完成 \033[0m"

## 移除旧版本

yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

echo -e "\033[42;34m 移除旧版本docker完成 \033[0m"

## 设置仓库

sudo yum install -y yum-utils

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

## 安装 docker

yum install -y docker-ce docker-ce-cli containerd.io

## 启动并设置为开机启动

systemctl start docker

systemctl enable docker

echo -e "\033[42;34m docker安装完成 \033[0m"

# 2. 安装Portainer

## 创建volume

docker volume create portainer_data

## pull docker

docker run -d \
	-p 8000:8000 \
	-p 9000:9000 \
	--name=portainer \
	--restart=always \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v portainer_data:/data \
	portainer/portainer-ce

echo -e "\033[42;34m portainer安装完成 \033[0m"

# 3. 申请域名证书

## pull acme docker

docker run --rm  -itd  \
  --net=host \
  --name=acme.sh \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "/home/docker/acme/ssl":/acme.sh  \
  neilpang/acme.sh daemon

echo -e "\033[42;34m acme 镜像拉取完成 \033[0m"

## 申请域名证书

docker exec \
    -e GD_Email=2262669715@qq.com \
    -e GD_Key=dLYsjofXCoDk_6kiiYG8qhZkp5peeNjsqhm \
    -e GD_Secret=RTAaiB1JjkoDJJwzd3P7Vw \
    acme.sh --issue -d vitamingcheng.space --dns dns_gd

echo -e "\033[42;34m acme vitamingcheng.com ssl申请完成 \033[0m"

docker exec \
    -e GD_Email=2262669715@qq.com \
    -e GD_Key=dLYsjofXCoDk_6kiiYG8qhZkp5peeNjsqhm \
    -e GD_Secret=RTAaiB1JjkoDJJwzd3P7Vw \
    acme.sh --issue -d *.vitamingcheng.space --dns dns_gd

echo -e "\033[42;34m acme *.vitamingcheng.com ssl申请完成 \033[0m"    
