FROM gitpod/workspace-full

RUN brew install terraform

USER gitpod
RUN echo "function gi() { }"