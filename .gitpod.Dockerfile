FROM gitpod/workspace-full

RUN brew install terraform
RUN sudo curl https://raw.githubusercontent.com/samstav/terraform-plugin-installer/master/install.sh | bash -s -- https://github.com/Mongey/terraform-provider-confluentcloud
