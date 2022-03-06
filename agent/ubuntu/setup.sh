#!/bin/bash

# Update the package listing:
apt-get update

# Security updates:
apt-get -y upgrade

# Common packages
apt-get install -y --no-install-recommends \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    wget \
    curl \
    jq \
    git \
    iputils-ping \
    unzip \
    libcurl4 \
    libunwind8 \
    netcat \
    libssl1.0

# Distro based prerequisites
curl -LO http://ftp.us.debian.org/debian/pool/main/i/icu/libicu57_57.1-6+deb9u4_amd64.deb
dpkg -i libicu57_57.1-6+deb9u4_amd64.deb
rm libicu57_57.1-6+deb9u4_amd64.deb

# kubectl
curl -LO https://dl.k8s.io/release/v1.23.0/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl

# Helm
curl -LO https://get.helm.sh/helm-v3.7.2-linux-amd64.tar.gz
tar xvf helm-v3.7.2-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin
rm helm*
rm -r linux-*

# Azure CLI
curl -LsS https://aka.ms/InstallAzureCLIDeb | bash
rm -rf /var/lib/apt/lists/*

# Ansible
apt-add-repository ppa:ansible/ansible -y
apt-get update
apt install python3-pip -y
pip3 install pywinrm
pip3 install pyvmomi
pip3 install ansible

# Terraform
wget https://releases.hashicorp.com/terraform/1.1.3/terraform_1.1.3_linux_amd64.zip
unzip terraform_1.1.3_linux_amd64.zip
mv terraform /usr/local/bin/

# PowerShell
wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
apt-get update
apt-get install -y powershell

# PowerShell AZ module
pwsh -c "&{Install-Module -Name Az -AllowClobber -Scope AllUsers -Force -Verbose}"

# Delete cached files we don't need anymore
apt-get clean

# Delete index files we don't need anymore
rm -rf /var/lib/apt/lists/*