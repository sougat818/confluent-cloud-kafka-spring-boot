
# Install confluent cloud provider plugin for terraform
# There is a bug in the latest release, deploying from the fixed commit. We can simply remove the commit id when a new release is available
curl https://raw.githubusercontent.com/stavxyz/terraform-plugin-installer/master/install.sh | bash -s -- https://github.com/Mongey/terraform-provider-confluentcloud 17c01e8598f9c266efd1b8938d88b889a5d841ae
