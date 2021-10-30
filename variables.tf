##################################################################
#Variable Files
##################################################################

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "network_cidr" {
  description = "CIDR for VPC"
  default     = "20.0.0.0/16"
}

variable "name" {
  description = "project name"
  default     = "pedrotest"
}

#Define the IP
variable "customer_ips" {
  type        = list(string)
  description = "A list of public IPs"
  default     = ["212.163.33.165/32", "176.83.174.40/32"] 
}

variable "http_instance_port" {
  description = "http_instance_port"
  default     = "80"
}

variable key_pair_pem{}
variable key_pair_name{}
variable instance_type{}
variable instance_ami{}