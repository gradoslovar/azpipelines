# #https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops&WT.mc_id=AZ-MVP-5003246&WT.mc_id=AZ-MVP-5003246#create-and-build-the-dockerfile-1

# FROM ubuntu:20.04

# # To make it easier for build and release pipelines to run apt-get,
# # configure apt to not require confirmation (assume the -y argument by default)
# ENV DEBIAN_FRONTEND=noninteractive
# RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

# RUN apt-get update && apt-get install -y --no-install-recommends \
#     ca-certificates \
#     curl \
#     jq \
#     git \
#     iputils-ping \
#     libcurl4 \
#     libunwind8 \
#     netcat \
#     libssl1.0 \
#   && rm -rf /var/lib/apt/lists/*

# RUN curl -LsS https://aka.ms/InstallAzureCLIDeb | bash \
#   && rm -rf /var/lib/apt/lists/*

# ARG TARGETARCH=amd64
# ARG AGENT_VERSION=2.194.0

# WORKDIR /azp
# RUN if [ "$TARGETARCH" = "amd64" ]; then \
#       AZP_AGENTPACKAGE_URL=https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz; \
#     else \
#       AZP_AGENTPACKAGE_URL=https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-${TARGETARCH}-${AGENT_VERSION}.tar.gz; \
#     fi; \
#     curl -LsS "$AZP_AGENTPACKAGE_URL" | tar -xz

# COPY agent/ubuntu/start.sh .
# RUN chmod +x start.sh

# ENTRYPOINT [ "./start.sh" ]
FROM rabbitmq:3.9.10-management

LABEL maintainer="devops@alsid.com"
LABEL product=AlsidForAD

# Create folders for Certificates
RUN mkdir -p /etc/ssl/certs/ca
RUN mkdir -p /etc/ssl/certs/server

# Create CA cert placeholder
RUN touch /etc/ssl/certs/ca/alsidforad.ca.users.crt

# Create Alsid app wildcard cert and key placeholders
RUN touch /etc/ssl/certs/server/alsid.app.crt
RUN touch /etc/ssl/certs/server/alsid.app.key

# Copy RabbitMQ configuration file
COPY rabbitmq.conf /etc/rabbitmq/rabbitmq.conf

# Copy RabbitMQ custom definition schema
COPY definitions.json /etc/rabbitmq/definitions.json

# Enable Prometheus plugin
RUN rabbitmq-plugins enable rabbitmq_prometheus

EXPOSE 15671