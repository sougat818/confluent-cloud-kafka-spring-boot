FROM gitpod/workspace-full

RUN brew install terraform

USER gitpod
RUN echo \"function gi() { curl -sL https://www.toptal.com/developers/gitignore/api/\\$@ ;}\" >> ~/.bashrc && source ~/.bashrc