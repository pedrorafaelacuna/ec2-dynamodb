#Terraform settings
#Bucket S3 for tfstate storage
terraform {
  backend "s3" {
    bucket = "cloud-ops-es"
    key    = "sbox"
    region = "eu-west-1"
  }
}

# The default provider configuration for AWS; resources that begin with `aws_` will use
# it as the default, and it can be referenced as `aws`.
provider "aws" {
  region = "eu-west-1"
}
