FROM centos:latest
MAINTAINER Song Chang an <casong99@gmail.com>

# Install centos
RUN mkdir install_tmp
WORKDIR /install_tmp
RUN yum -y update
RUN curl -LO https://centos7.iuscommunity.org/ius-release.rpm 
RUN yum install -y ius-release.rpm
RUN yum install -y python36u python36u-devel python36u-libs python36u-pip java-1.8.0-openjdk-devel.x86_64 wget unzip git
RUN curl -LO https://bootstrap.pypa.io/get-pip.py

# install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.12.0/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

# install ncloud cli
RUN curl -o ncloud_cli.zip https://www.ncloud.com/api/support/download/1485
RUN unzip ncloud_cli.zip
RUN cp -r cli_linux /usr/local/bin/.
RUN chmod +x /usr/local/bin/cli_linux/ncloud
RUN sed -i 's#./jre7/#/usr/local/bin/cli_linux/jre7/#g' /usr/local/bin/cli_linux/ncloud
RUN sed -i 's#./lib/#/usr/local/bin/cli_linux/lib/#g' /usr/local/bin/cli_linux/ncloud
RUN chmod +x /usr/local/bin/cli_linux/jre7/bin/*
RUN ln -s /usr/local/bin/cli_linux/ncloud /usr/local/bin/ncloud

# install Terraform 
RUN curl -LO https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip
RUN unzip terraform_0.11.14_linux_amd64.zip && mv terraform /usr/bin/.

# install packer
RUN curl -LO https://releases.hashicorp.com/packer/1.4.2/packer_1.4.2_linux_amd64.zip
RUN unzip packer_1.4.2_linux_amd64.zip
RUN mv packer /usr/local/bin/.

# clean up tmpfile
# RUN rm -rf /usr/local/ncloud_cli.zip && /usr/local/cli_window/*
RUN rm -rf install_tmp
