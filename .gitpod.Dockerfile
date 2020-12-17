FROM gitpod/workspace-full

RUN brew install kind

RUN . /etc/os-release
RUN echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
RUN curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key

RUN sudo apt-get update && \
    sudo apt-get -y upgrade && \
    sudo apt-get -y install podman