# Virtual Private Cloud
resource "aws_vpc" "custom_vpc" {
    cidr_block       = var.cidr_block_vpc
    instance_tenancy = "default"
    
    tags = {
        Name = "Custom VPC"
    }
}

# Internet gateway to give internet access to our Custom VPC
resource "aws_internet_gateway" "custom_internet_gateway" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "Custom Internet Gateway"
  }
}

# Route table of the internet gateway to specify the connection to the internet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
        cidr_block = "0.0.0.0/0" // Route to the internet
        gateway_id = aws_internet_gateway.custom_internet_gateway.id  //IGW to Internet
    }

  tags = {
    Name = "Custom route table"
  }
}


# Associates the public subnet to the route table that connects it to the internet
resource "aws_route_table_association" "custom_public_subnet_route_association"{
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route_table.id
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
    vpc_id                   = aws_vpc.custom_vpc.id
    availability_zone        = var.availability_zone_1
    cidr_block               = var.cidr_block_public_subnet
    map_public_ip_on_launch  = true // It makes this a public subnet
}

# Private Subnet
resource "aws_subnet" "private_subnet_1" {
    vpc_id            = aws_vpc.custom_vpc.id
    availability_zone = var.availability_zone_1
    cidr_block        = var.cidr_block_private_subnet_1 
}

# Private Subnet
resource "aws_subnet" "private_subnet_2" {
    vpc_id            = aws_vpc.custom_vpc.id
    availability_zone = var.availability_zone_2
    cidr_block        = var.cidr_block_private_subnet_2 
}


# Allows SSH and HTTP traffic on EC2 instance
resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP traffic on EC2 instance"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    description = "SSH to EC2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP to EC2"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_http"
  }
}

# Allows connection between EC2 instance and RDS
resource "aws_security_group" "allow_ec2_call_RDS" {
  name        = "allow_ec2_call_RDS"
  description = "Allows connection between EC2 instance and RDS"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    description = "EC2 to RDS"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block_public_subnet]
  }

  tags = {
    Name = "allow_EC2_call_RDS"
  }
}

# EC2 Instance
resource "aws_instance" "projeto2" {
    ami                         = "ami-0fb4cf3a99aa89f72" // sa-east-1 ubuntu server  AMI
    instance_type               = "t2.micro"
    key_name                    = var.ssh_key_name
    vpc_security_group_ids      = [aws_security_group.allow_ssh_http.id]
    associate_public_ip_address = true
    subnet_id                   = aws_subnet.public_subnet.id

    tags = {
        Name = "projeto2"
    }
  
}