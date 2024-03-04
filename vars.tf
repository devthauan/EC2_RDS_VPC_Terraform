variable "ami" {
    default = "ami-0fb4cf3a99aa89f72" // sa-east-1 ubuntu server  AMI
}
variable "instance_type" {
    default = "t2.micro"
}

variable "ssh_key_name" {
    default = "EC2_ssh_key"
}

variable "cidr_block_vpc" {
    default = "10.0.0.0/16"
}

variable "cidr_block_public_subnet" {
    default = "10.0.1.0/24"
}

variable "cidr_block_private_subnet_1" {
    default = "10.0.2.0/24"
}

variable "cidr_block_private_subnet_2" {
    default = "10.0.3.0/24"
}

variable "availability_zone_1" {
    default = "sa-east-1a"
}

variable "availability_zone_2" {
    default = "sa-east-1b"
}

variable db_engine {
  default     = "mysql"
}

variable db_engine_version {
  default     = "5.7"
}

variable db_username {
  default     = "thauan"
}

variable db_password {
  default     = "thauan123123"
}