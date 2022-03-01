#!/bin/bash

# Update the package listing, so we know what package exist:
apt-get update

# Install security updates:
apt-get -y upgrade

####
apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    git \
    iputils-ping \
    libcurl4 \
    libunwind8 \
    netcat \
    libssl1.0

rm -rf /var/lib/apt/lists/* \
curl -LO https://dl.k8s.io/release/v1.23.0/bin/linux/amd64/kubectl \
chmod +x ./kubectl \
mv ./kubectl /usr/local/bin/kubectl \
curl -LO https://get.helm.sh/helm-v3.7.2-linux-amd64.tar.gz \
tar xvf helm-v3.7.2-linux-amd64.tar.gz \
mv linux-amd64/helm /usr/local/bin \
rm helm* && rm -r linux-*


# Delete cached files we don't need anymore (note that if you're
# using official Docker images for Debian or Ubuntu, this happens
# automatically, you don't need to do it yourself):
apt-get clean
# Delete index files we don't need anymore:
rm -rf /var/lib/apt/lists/*