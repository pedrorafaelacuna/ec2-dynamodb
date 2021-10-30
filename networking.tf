################################################################################
# Creation of VPC
################################################################################
module "test_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.10.0"
  name    = var.name
  cidr    = var.network_cidr

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["20.0.1.0/24", "20.0.2.0/24"]
  public_subnets  = ["20.0.3.0/24", "20.0.4.0/24"]

  enable_nat_gateway = false
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Deployed = "true"
  }
}
################################################################################
# VPC endpoint for s3
################################################################################
#VPC endpoint to safe tfstates. 

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.test_vpc.vpc_id
  service_name      = "com.amazonaws.eu-west-1.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = concat([module.test_vpc.vpc_main_route_table_id], module.test_vpc.private_route_table_ids, module.test_vpc.public_route_table_ids)

  private_dns_enabled = false
}

################################################################################
# Creation of Security Group for EC2
################################################################################
#Define the ips from which access is needed. In this case only port 22 is open, in case other ports are needed, open what to define for what to use and add them to the security group.

resource "aws_security_group" "test_sg" {
  name        = "${var.name}_test_sg"
  description = "Enables communication from Customers public IPs"
  vpc_id      = module.test_vpc.vpc_id

  ingress {
    description = "allow communication within the VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.network_cidr]
  }

  
  ingress {
    description = "SSH from Customer"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.customer_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform = "true"
  }

}

################################################################################
# Creation of VPC Endpoint for DynamoDB
################################################################################
# In this section we use a vpc endpoint to establish a more secure connection between the ec2 instance and the dynamodb table.

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = module.test_vpc.vpc_id
  service_name      = "com.amazonaws.eu-west-1.dynamodb"
  vpc_endpoint_type = "Gateway"

  route_table_ids = concat([module.test_vpc.vpc_main_route_table_id], module.test_vpc.private_route_table_ids, module.test_vpc.public_route_table_ids)

  private_dns_enabled = false
}