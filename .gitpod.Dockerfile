FROM gitpod/workspace-full

RUN brew install kind

RUN . /etc/os-release
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4D64390375060AA4
RUN echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.10/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
RUN curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.10/Release.key
RUN cat /etc/update-manager/release-upgrades
RUN sudo apt-get update && \
    sudo apt-get -y upgrade && \
    sudo apt-get -y install ubuntu-release-upgrader-core && \
    sudo apt-get -y dist-upgrade && \
    sudo do-release-upgrade -c && \
    sudo apt-get -y install podman