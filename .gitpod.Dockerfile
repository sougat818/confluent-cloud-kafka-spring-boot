FROM gitpod/workspace-full

RUN sudo apt-get update \
    && sudo apt install -y \
    apt-utils \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    uidmap \
    lxc \
    lxc-dev \
    kmod \
    software-properties-common \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - \
    && sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    xenial \
    stable" \
    && sudo apt-cache policy docker-ce \
    && sudo apt install -y docker-ce uidmap \
    && sudo service docker start \
    && sudo usermod -aG docker gitpod

USER gitpod
RUN export SKIP_IPTABLES=1 && curl -fsSL https://get.docker.com/rootless | sh
ENV XDG_RUNTIME_DIR=/tmp/docker-33333
ENV PATH=/home/gitpod/bin:$PATH
ENV DOCKER_HOST=unix:///tmp/docker-33333/docker.sock
USER root
RUN dockerd;docker run hello-world > /home/gitpod/out