# Subnet group for RDS
resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "rds_subnet_group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  tags = {
    Name = "RDS Subnet Group"
  }
}

# RDS instance
resource "aws_db_instance" "rds_db" {
  allocated_storage      = 10
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = "db.t2.micro"
  db_name                = "wikidb"
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.allow_ec2_call_RDS.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot    = true // required to destroy
}