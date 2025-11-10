# ------------------------
# Variables Global
# ------------------------

# Região AWS
variable "aws_region" {
  description = "Region where the infrastructure will be provisioned."
  type        = string
  default     = "us-east-1"
}

# Tag padrão de migração
variable "map_migrated" {
  description = "Migration control tag"
  type        = string
  default     = "migzw01"
}

# ------------------------
# VPC e Subnets
# ------------------------

# CIDR da VPC
variable "vpc_cidr" {
  description = "VPC Main CIDR Block"
  type        = string
  default     = "10.10.0.0/24"
}

# Subnet public
variable "public_subnet_cidr" {
  description = "CIDR of the public subnet"
  type        = string
  default     = "10.10.0.0/28"
}

# Subnet app (private)
variable "app_subnet_cidr" {
  description = "CIDR of the private subnet for the application."
  type        = string
  default     = "10.10.0.32/28"
}

# Subnet data (private)
variable "data_subnet_cidr" {
  description = "CIDR of the private subnet for database"
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
 description = "CIRD Block Internet Gateway"
 type = string
 default = "0.0.0.0/0"
} 

variable "route_table_nat" {
 description = "CIRD Block Nat Gateway"
 type = string
 default = "0.0.0.0/0"
} 

# ------------------------
# Bloco CIRD All Traffic
# ------------------------

variable "trafficinternet" {
  description = "Open communication bloc for the world"
  type        = string
  default     = "0.0.0.0/0"
}

# ------------------------
# Naming Default
# ------------------------

variable "project_name" {
  description = "Base name for the resources"
  type        = string
  default     = "model"
}

