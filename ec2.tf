# EC2 Instance
resource "aws_instance" "projeto2" {
    ami                         = var.ami
    instance_type               = var.instance_type
    key_name                    = var.ssh_key_name
    vpc_security_group_ids      = [aws_security_group.allow_ssh_http.id]
    associate_public_ip_address = true
    subnet_id                   = aws_subnet.public_subnet.id

    tags = {
        Name = "project2"
    }
  
}