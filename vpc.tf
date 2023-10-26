
resource "aws_vpc" "Rock-vpc" {
 cidr_block = "10.0.0.0/16"
 
 tags = {
   Name = "Rocks Vpc"
 }
}
# rock public subnet
resource "aws_subnet" "Rock_public_subnets" {
 count      = length(var.public_subnet_cidrs)
 vpc_id     = aws_vpc.Rock-vpc.id
 cidr_block = element(var.public_subnet_cidrs, count.index)
 
 tags = {
   Name = "Public Subnet ${count.index + 1}"
 }
}
 #rock private subnet
resource "aws_subnet" "Rock_private_subnets" {
 count      = length(var.private_subnet_cidrs)
 vpc_id     = aws_vpc.Rock-vpc.id
 cidr_block = element(var.private_subnet_cidrs, count.index)
 
 tags = {
   Name = "Private Subnet ${count.index + 1}"
 }
}

# rock igw
resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.Rock-vpc.id
 
 tags = {
   Name = "Project VPC IGW"
 }
}
# rock public route table
resource "aws_route_table" "Rock-pub-route-table" {
  vpc_id = aws_vpc.Rock-vpc.id

  tags = {
    Name = "Rock-pub-route-table"
  }
}

# pro private route table
resource "aws_route_table" "Rock-private-route-table" {
  vpc_id = aws_vpc.Rock-vpc.id

  tags = {
    Name = "Rock-pri-route-table"
  }
}

# public subnet association
resource "aws_route_table_association" "public_subnet_association" {
 count          = length(var.public_subnet_cidrs)
 subnet_id      = element(aws_subnet.Rock_public_subnets.*.id, count.index)
 route_table_id = aws_route_table.Rock-pub-route-table.id
}

#private subnet association
resource "aws_route_table_association" "private_subnet_association" {
 count          = length(var.private_subnet_cidrs)
 subnet_id      = element(aws_subnet.Rock_private_subnets.*.id, count.index)
 route_table_id = aws_route_table.Rock-private-route-table.id
}

#route for internet gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id = aws_route_table.Rock-pub-route-table.id
destination_cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.gw.id
}


# Create Elastic IP Address
resource "aws_eip" "rock-eip" {
  tags = {
    Name = "rock-eip"
  }
}
# Create NAT Gateway
resource "aws_nat_gateway" "rock_NGW" {
  allocation_id = aws_eip.rock-eip.id
  subnet_id     = element(aws_subnet.Rock_public_subnets.*.id,0 ) 

  tags = {
    Name = "rock-nat-gw"
  }
}# NAT Associate with Priv route
resource "aws_route" "private_nat_ass" {
  route_table_id = aws_route_table.Rock-private-route-table.id
  gateway_id = aws_nat_gateway.rock_NGW.id
  destination_cidr_block = "0.0.0.0/0"
}

