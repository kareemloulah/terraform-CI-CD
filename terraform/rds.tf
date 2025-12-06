resource "aws_db_subnet_group" "intern" {
  name       = "intern"
  subnet_ids = [aws_subnet.private1.id, aws_subnet.private2.id]

  tags = {
    Name = "My DB subnet group"
  }
}
resource "aws_db_instance" "intern" {
  allocated_storage      = 10
  db_name                = "mydb"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "supersecurepassword"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.intern.name
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.db-sg.id, ]
}
resource "aws_security_group" "db-sg" {
  name        = "db-sg"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.intern.id
}

resource "aws_vpc_security_group_ingress_rule" "allow-back-sg" {
  security_group_id            = aws_security_group.db-sg.id
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.back_sg.id
}
