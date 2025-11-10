# ------------------------
# Variables Global
# ------------------------

# Região AWS
variable "aws_region" {
  description = "Região onde a infraestrutura será provisionada"
  type        = string
  default     = "us-east-1"
}

# Tag padrão de migração
variable "map_migrated" {
  description = "Tag de controle de migração"
  type        = string
  default     = "migzw01"
}

# ------------------------
# VPC e Subnets
# ------------------------

# CIDR da VPC
variable "vpc_cidr" {
  description = "Bloco CIDR principal da VPC"
  type        = string
  default     = "10.10.0.0/24"
}

# Subnet public
variable "public_subnet_cidr" {
  description = "CIDR da subnet pública"
  type        = string
  default     = "10.10.0.0/28"
}

# Subnet app (private)
variable "app_subnet_cidr" {
  description = "CIDR da subnet privada para aplicação"
  type        = string
  default     = "10.10.0.32/28"
}

# Subnet data (private)
variable "data_subnet_cidr" {
  description = "CIDR da subnet privada para dados/banco"
  type        = string
  default     = "10.10.0.64/28"
}

# Availability Zone Default
variable "availability_zone" {
  description = "Zona de disponibilidade para as subnets"
  type        = string
  default     = "us-east-1a"
}
                                                                                               
variable "route_table_igw" {
 description = "Bloco CIRD Internet Gateway"
 type = string
 default = "0.0.0.0/0"
} 

variable "route_table_nat" {
 description = "Bloco CIRD Nat Gateway"
 type = string
 default = "0.0.0.0/0"
} 

# ------------------------
# Bloco CIRD All Traffic
# ------------------------

variable "trafficinternet" {
  description = "Bloco Aberto de comunicao para o mundo"
  type        = string
  default     = "0.0.0.0/0"
}

# ------------------------
# Naming Default
# ------------------------

variable "project_name" {
  description = "Nome base para os recursos"
  type        = string
  default     = "model"
}
