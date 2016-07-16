FROM nvidia/cuda:7.5-cudnn5-devel
MAINTAINER xplo <xplo@xplo.org>

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# Prepare ubuntu prereqs
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
    software-properties-common \
    curl \
    wget \
    vim nano \ 
    libprotobuf-dev protobuf-compiler && \
  cd ~/ && \
  curl -s https://raw.githubusercontent.com/torch/ezinstall/master/install-deps | bash && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install torch
RUN git clone https://github.com/torch/distro.git ~/torch --recursive && \
  cd ~/torch && \
  ./install.sh

# Install caffee and bindings
RUN /bin/bash -c "source /root/torch/install/bin/torch-activate && \
  luarocks install loadcaffe"

# Install neural style
RUN /bin/bash -c "cd ~/ && \
  source /root/torch/install/bin/torch-activate && \
  git clone https://github.com/jcjohnson/neural-style.git && \
  cd neural-style && \
  sh models/download_models.sh"

# Slimming down the image
RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /root/neural-style

VOLUME /root/neural-style/models
VOLUME /root/neural-style/images
VOLUME /root/neural-style/outputs
