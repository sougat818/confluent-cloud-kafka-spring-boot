FROM gitpod/workspace-full

RUN brew install terraform

RUN brew tap wn/homebrew-tap
RUN brew install gitignore