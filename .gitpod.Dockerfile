FROM gitpod/workspace-full

RUN brew install kind

RUN sudo apt-get update && \
    sudo apt-get -y install podman