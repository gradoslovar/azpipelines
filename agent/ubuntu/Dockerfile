# #https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops&WT.mc_id=AZ-MVP-5003246&WT.mc_id=AZ-MVP-5003246#create-and-build-the-dockerfile-1

FROM ubuntu:20.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    git \
    iputils-ping \
    libcurl4 \
    libunwind8 \
    netcat \
    libssl1.0 \
  && rm -rf /var/lib/apt/lists/* \
  && curl -LO https://dl.k8s.io/release/v1.23.0/bin/linux/amd64/kubectl \
  && chmod +x ./kubectl \
  && mv ./kubectl /usr/local/bin/kubectl \
  && curl -LO https://get.helm.sh/helm-v3.7.2-linux-amd64.tar.gz \
  && tar xvf helm-v3.7.2-linux-amd64.tar.gz \
  && mv linux-amd64/helm /usr/local/bin \
  && rm helm* && rm -r linux-*

RUN curl -LO http://ftp.us.debian.org/debian/pool/main/i/icu/libicu57_57.1-6+deb9u4_amd64.deb \
  &&  dpkg -i libicu57_57.1-6+deb9u4_amd64.deb \
  &&  rm libicu57_57.1-6+deb9u4_amd64.deb

RUN curl -LsS https://aka.ms/InstallAzureCLIDeb | bash \
  && rm -rf /var/lib/apt/lists/*

# RUN apt install software-properties-common \
#   && apt-add-repository ppa:ansible/ansible \
#   && apt update 

RUN apt-add-repository ppa:ansible/ansible -y\
 && apt-get update \
 && apt install python3-pip -y \
 && pip3 install pywinrm \
 && pip3 install pyvmomi \
 && pip3 install ansible

ARG TARGETARCH=amd64
ARG AGENT_VERSION=2.194.0

WORKDIR /azp
RUN if [ "$TARGETARCH" = "amd64" ]; then \
      AZP_AGENTPACKAGE_URL=https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz; \
    else \
      AZP_AGENTPACKAGE_URL=https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-${TARGETARCH}-${AGENT_VERSION}.tar.gz; \
    fi; \
    curl -LsS "$AZP_AGENTPACKAGE_URL" | tar -xz

COPY agent/ubuntu/start.sh .
RUN chmod +x start.sh

ENTRYPOINT [ "./start.sh" ]