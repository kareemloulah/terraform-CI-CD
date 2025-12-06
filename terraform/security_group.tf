################
# Security group
################
# FRONT
resource "aws_security_group" "front_sg" {
  name        = "front_sg"
  description = "Allow ssh/http inbound traffic"
  vpc_id      = aws_vpc.intern.id
}
resource "aws_vpc_security_group_egress_rule" "allow_all_egress_front" {
  security_group_id = aws_security_group.front_sg.id
  ip_protocol       = "-1" # all protocols
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_front" {
  security_group_id = aws_security_group.front_sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0" # should be my personal IP
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_front" {
  security_group_id = aws_security_group.front_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}
# BACK
resource "aws_security_group" "back_sg" {
  name        = "back_sg"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.intern.id
}
resource "aws_vpc_security_group_egress_rule" "allow_all_egress_back" {
  security_group_id = aws_security_group.back_sg.id
  ip_protocol       = "-1" # all protocols
  cidr_ipv4         = "0.0.0.0/0"
}
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.back_sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0" # should be my personal IP
}
resource "aws_vpc_security_group_ingress_rule" "allow_traffic_sg" {
  # allows all traffic from front-sg as an example 
  security_group_id            = aws_security_group.back_sg.id
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.front_sg.id
}
