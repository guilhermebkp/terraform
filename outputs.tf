
# ------------------------
# output Bloco CIDR
# ------------------------
output "aws_vpc" {
value = aws_vpc.vpc_model.cidr_block
description = "Bloco CIDR da VPC"      
}

# ------------------------
# output Bloco Subnet Public
# ------------------------
output "aws_vpc" {
value = aws_subnet.public_subnet_pub.cidr_block
description = "Bloco CIRD Subnet Publica"
}

# ------------------------
# output Bloco Subnet App
# ------------------------
output "aws_vpc" {
value = aws_subnet.private_subnet_app.cidr_block
description = "Bloco CIRD Subnet App"
}

# ------------------------
# output Bloco Subnet Data
# ------------------------
output "aws_vpc" {
value = aws_subnet.private_subnet_data.cidr_block
description = "Bloco CIRD Subnet Data"
}


# ------------------------
# output Route Table Public
# ------------------------
output "aws_vpc" {
value = aws_route_table.rtb_public.route
description = "Blocos associados a tabela de public"
}

# ------------------------
# output Route Table App
# ------------------------
output "aws_vpc" {
value = aws_route_table.rtb_app.route
description = "Blocos associados a tabela de rota app"
}

# ------------------------
# output Route Table Data
# ------------------------
output "aws_vpc" {
value = aws_route_table.rtb_data.route
description = "Blocos associados a tabela de rota data"
}
