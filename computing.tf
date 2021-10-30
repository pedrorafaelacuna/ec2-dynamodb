##################################################################
#Creation of Key Pair
##################################################################
#Its high recommended save the credentials in a aws vault service like secret manager or parameter store with least privilege permissions.

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = var.key_pair_name
  public_key = var.key_pair_pem 

}

##################################################################
#Creation of EC2 Instances
##################################################################
#Ec2 instance in a private subnet without access to/from internet

resource "aws_instance" "test_ec2" {

  ami                         = var.instance_ami
  instance_type               = var.instance_type
  subnet_id                   = module.test_vpc.private_subnets[0]
  associate_public_ip_address = false
  key_name                    = var.key_pair_name
  vpc_security_group_ids      = [aws_security_group.test_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.test_profile.name

  root_block_device {
    delete_on_termination     = true
    volume_size               = 30
    volume_type               = "gp2"
    encrypted                 = true
  }

    tags = {
    Name                      ="ec2-instance"

  }
}

