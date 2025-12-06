######
# VARS
######
variable "aws_region" {
  description = "AWS REGION"
  type        = string
  default     = "eu-west-2"
}
variable "availability_zone-0" {
  description = "public AZ"
  type        = string
  default     = "eu-west-2a"
}
variable "availability_zone-1" {
  description = "private AZ"
  type        = string
  default     = "eu-west-2b"
}
####################################################
################
# VPC and SUBNET
################
resource "aws_vpc" "intern" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.intern.id
  availability_zone       = var.availability_zone-0
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.intern.id
  availability_zone = var.availability_zone-1
  cidr_block        = "10.0.3.0/24"
}
resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.intern.id
  availability_zone = var.availability_zone-0
  cidr_block        = "10.0.4.0/24"
}
####################################################
#############
# ROUTE TABLE
#############
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.intern.id
}
########
# public
########
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.intern.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
resource "aws_route_table_association" "public-1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public-2" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}
#########
# Private
#########
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.intern.id
}
resource "aws_route_table_association" "private-1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private-2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}
######################################################
