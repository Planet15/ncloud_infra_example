FROM alpine:3.7

MAINTAINER Song Chang an <changan.song@navercorp.com>

RUN mkdir ncloud 
WORKDIR /ncloud
RUN apk update 
RUN apk add --no-cache openjdk8 python3 wget unzip git ansible curl bash

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.12.0/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl \
    && curl -LO https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip \
    && unzip terraform_0.12.26_linux_amd64.zip \
    && mv terraform /usr/local/bin/. \
    && rm terraform_0.12.26_linux_amd64.zip \
    && curl -LO https://releases.hashicorp.com/packer/1.4.2/packer_1.4.2_linux_amd64.zip \
    && unzip packer_1.4.2_linux_amd64.zip \
    && mv packer /usr/local/bin/. \
    && rm -rf packer_1.4.2_linux_amd64.zip \
    && curl -LO https://raw.githubusercontent.com/Planet15/ncloud_infra_example/master/ncloud_cli_1.0.22_20200616.zip \
    && unzip ncloud_cli_1.0.22_20200616.zip \
    && mv ncloud-api-cli-1.0.22-SNAPSHOT-jar-with-dependencies.jar /lib/. \
    && chmod +x ./ncloud \
    && mv ncloud /usr/local/bin/. \
    && rm -rf ncloud_cli_1.0.22_20200616.zip
