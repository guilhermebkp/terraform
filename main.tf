terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.18"
    }
  }
}

# Provedor e Região
provider "aws" {
  region = var.aws_region
}

# ------------------------
# VPC
# ------------------------
resource "aws_vpc" "vpc_model" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name          = "vpc-model"
    map-migrated  = var.map_migrated
  }
}

# ------------------------
# Subnets
# ------------------------
resource "aws_subnet" "public_subnet_pub" {
  vpc_id                  = aws_vpc.vpc_model.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name          = "snb-model-pub"
    map-migrated  = var.map_migrated
  }
}

resource "aws_subnet" "private_subnet_app" {
  vpc_id            = aws_vpc.vpc_model.id
  cidr_block        = var.app_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name          = "snb-model-app"
    map-migrated  = var.map_migrated
  }
}

resource "aws_subnet" "private_subnet_data" {
  vpc_id            = aws_vpc.vpc_model.id
  cidr_block        = var.data_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name          = "snb-model-data"
    map-migrated  = var.map_migrated
  }
}

# ------------------------
# Internet Gateway e NAT
# ------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_model.id

  tags = {
    Name          = "igw-model"
    map-migrated  = var.map_migrated
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "eip-nat-model"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_pub.id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name          = "ngw-model-01"
    map-migrated  = var.map_migrated
  }
}

# ------------------------
# Route Tables e association
# ------------------------
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc_model.id

  route {
    cidr_block = var.route_table_igw
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name          = "rtb-model-public"
    map-migrated  = var.map_migrated
  }
}

resource "aws_route_table_association" "assoc_public" {
  subnet_id      = aws_subnet.public_subnet_pub.id
  route_table_id = aws_route_table.rtb_public.id
}

resource "aws_route_table" "rtb_app" {
  vpc_id = aws_vpc.vpc_model.id

  route {
    cidr_block     = var.route_table_nat
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name          = "rtb-model-app"
    map-migrated  = var.map_migrated
  }
}

resource "aws_route_table_association" "assoc_app" {
  subnet_id      = aws_subnet.private_subnet_app.id
  route_table_id = aws_route_table.rtb_app.id
}

resource "aws_route_table" "rtb_data" {
  vpc_id = aws_vpc.vpc_model.id

  route {
    cidr_block     = var.route_table_nat
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name          = "rtb-model-data"
    map-migrated  = var.map_migrated
  }
}

resource "aws_route_table_association" "assoc_data" {
  subnet_id      = aws_subnet.private_subnet_data.id
  route_table_id = aws_route_table.rtb_data.id
}

# ------------------------
# Network ACLs
# ------------------------
resource "aws_network_acl" "acl_pub" {
  vpc_id = aws_vpc.vpc_model.id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.trafficinternet.cidr_block
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = var.trafficinternet.cidr_block
    from_port  = 443
    to_port    = 443
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.trafficinternet.cidr_block
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name          = "acl-model-pub"
    map-migrated  = var.map_migrated
  }
}

resource "aws_network_acl" "acl_app" {
  vpc_id = aws_vpc.vpc_model.id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.10.0.0/24"
    from_port  = 0
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.trafficinternet.cidr_block
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name          = "acl-model-app"
    map-migrated  = var.map_migrated
  }
}

resource "aws_network_acl" "acl_data" {
  vpc_id = aws_vpc.vpc_model.id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.trafficinternet.cidr_block
    from_port  = 0
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.trafficinternet.cidr_block
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name          = "acl-model-data"
    map-migrated  = var.map_migrated
  }
}

# Associações NACL
resource "aws_network_acl_association" "acl_assoc_pub" {
  network_acl_id = aws_network_acl.acl_pub.id
  subnet_id      = aws_subnet.public_subnet_pub.id
}

resource "aws_network_acl_association" "acl_assoc_app" {
  network_acl_id = aws_network_acl.acl_app.id
  subnet_id      = aws_subnet.private_subnet_app.id
}

resource "aws_network_acl_association" "acl_assoc_data" {
  network_acl_id = aws_network_acl.acl_data.id
  subnet_id      = aws_subnet.private_subnet_data.id
}

# ------------------------
# Security Groups
# ------------------------
resource "aws_security_group" "sgr_pub" {
  name        = "sgr-model-pub"
  description = "Access from Internet"
  vpc_id      = aws_vpc.vpc_model.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.trafficinternet.cidr_block
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.trafficinternet.cidr_block
  }

  tags = {
    Name          = "sgr-model-pub"
    map-migrated  = var.map_migrated
  }
}

resource "aws_security_group" "sgr_app" {
  name        = "sgr-model-app"
  description = "Access from app subnet"
  vpc_id      = aws_vpc.vpc_model.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.trafficinternet.cidr_block
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.trafficinternet.cidr_block
  }

  tags = {
    Name          = "sgr-model-app"
    map-migrated  = var.map_migrated
  }
}

resource "aws_security_group" "sgr_data" {
  name        = "sgr-model-data"
  description = "Access from app to data subnet"
  vpc_id      = aws_vpc.vpc_model.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.trafficinternet.cidr_block
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.trafficinternet.cidr_block
  }

  tags = {
    Name          = "sgr-model-data"
    map-migrated  = var.map_migrated
  }
}



