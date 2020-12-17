FROM gitpod/workspace-full

RUN brew install kind

RUN apt-get -y install podman