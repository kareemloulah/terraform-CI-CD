#################
# Instances setup
#################
data "aws_ami" "ubuntu_2204" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
##########
# Key Pair
##########
resource "tls_private_key" "intern" {
  algorithm = "RSA"
  rsa_bits  = 4096
  #   lifecycle {
  #     prevent_destroy = true
  #   }
}

resource "aws_key_pair" "intern" {
  key_name   = "intern-keypair"
  public_key = tls_private_key.intern.public_key_openssh
}
resource "local_file" "private_key" {
  content  = tls_private_key.intern.private_key_pem
  filename = "${path.module}/intern-keypair.pem"
}
##########
# instance 
##########
resource "aws_instance" "front_server" {

  ami = data.aws_ami.ubuntu_2204.id

  instance_type = "t3.micro"

  subnet_id = aws_subnet.public1.id

  vpc_security_group_ids = [aws_security_group.front_sg.id]

  key_name                    = aws_key_pair.intern.key_name
  associate_public_ip_address = true

}
resource "aws_instance" "back_server" {

  ami = data.aws_ami.ubuntu_2204.id

  instance_type = "t3.micro"

  subnet_id = aws_subnet.public1.id

  vpc_security_group_ids = [aws_security_group.back_sg.id]

  key_name = aws_key_pair.intern.key_name

  associate_public_ip_address = true

}
output "ssh" {
  value = {
    front = "ssh -i intern-keypair.pem ec2-user@${aws_instance.front_server.public_ip}"
    back  = "ssh -i intern-keypair.pem ec2-user@${aws_instance.back_server.public_ip}"
    rds   = "${aws_db_instance.intern.endpoint}"
  }
} 