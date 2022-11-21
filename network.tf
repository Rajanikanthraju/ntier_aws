# Creating VPC
resource "aws_vpc" "ntier" {
 cidr_block = var.vpc_cidr_range
 tags = {
   "Name" = "vpcfromtf"
 }
  
}

# Creating  S3 Bucket
resource "aws_s3_bucket" "s3bucket" {

    bucket = var.s3bucket

    tags = {
      "Name" = "my-bucket"
      "Environment"= "Dev"
    }
  
}

# Creating Internet Gateway
resource "aws_internet_gateway" "igw" {
vpc_id = aws_vpc.ntier.id
tags = {
  "Name" = "igwfromtf"
}
depends_on = [
  aws_vpc.ntier
]
  
}

# Creating Subnets
resource "aws_subnet" "subnets" {
    count=length(var.subnet_tags)
    vpc_id = aws_vpc.ntier.id
    cidr_block = cidrsubnet(var.vpc_cidr_range,8,count.index)
    availability_zone = format("${var.target_region}%s",count.index%2==0?"a":"b")
    tags = {
      "Name" = var.subnet_tags[count.index]
    }
  depends_on = [
    aws_vpc.ntier
  ]
}

# Creating Web Security Group
resource "aws_security_group" "websg" {
  vpc_id = aws_vpc.ntier.id
  description = local.default_description
  ingress {
    cidr_blocks = [local.cidr_anywhere]
    description = "allow ssh"
    from_port = local.ssh_port
    protocol = local.tcp
    to_port = local.ssh_port
  } 
  ingress {
    cidr_blocks = [local.cidr_anywhere]
    description = "allow http"
    from_port = local.http_port
    protocol = local.tcp
    to_port = local.http_port
  } 
  egress {
    from_port        = local.anywhere_port
    to_port          = local.anywhere_port
    protocol         = local.any_where_protocol
    cidr_blocks      = [local.cidr_anywhere]
    ipv6_cidr_blocks = [local.default_ipv6]
  }
  
  tags = {
    "Name" = "WebSG"
  }
  depends_on = [
    aws_vpc.ntier
  ]
}

# Creating App security group
resource "aws_security_group" "appsg" {
  vpc_id = aws_vpc.ntier.id
  description = "Created From Terraform"
  ingress {
    cidr_blocks = [ var.vpc_cidr_range ]
    description = "allow ssh"
    from_port = local.ssh_port
    protocol = local.tcp
    to_port = local.ssh_port
  } 
  ingress {
    cidr_blocks = [ var.vpc_cidr_range ]
    description = "allow http"
    from_port = local.app_port
    protocol = local.tcp
    to_port = local.app_port
  } 
  egress {
    from_port        = local.anywhere_port
    to_port          = local.anywhere_port
    protocol         = local.any_where_protocol
    cidr_blocks      = [local.cidr_anywhere]
    ipv6_cidr_blocks = [local.default_ipv6]
  }
  
  tags = {
    "Name" = "AppSG"
  }
  depends_on = [
    aws_vpc.ntier
  ]
}

# Creating  Db Security Group
resource "aws_security_group" "dbsg" {
  vpc_id = aws_vpc.ntier.id
  description = "Created From Terraform"
  ingress {
    cidr_blocks = [ var.vpc_cidr_range ]
    description = "allow ssh"
    from_port = local.ssh_port
    protocol = local.tcp
    to_port = local.ssh_port
  }
  ingress {
    cidr_blocks = [ var.vpc_cidr_range ]
    description = "allow http"
    from_port = local.db_port
    protocol = local.tcp
    to_port = local.db_port
  } 
  egress {
    from_port        = local.anywhere_port
    to_port          = local.anywhere_port
    protocol         = local.any_where_protocol
    cidr_blocks      = [local.cidr_anywhere]
    ipv6_cidr_blocks = [local.default_ipv6]
  }
  
  tags = {
    "Name" = "DbSG"
  }
  depends_on = [
    aws_vpc.ntier
  ]
}


#Creating Public Route Table
resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.ntier.id
  route{
    cidr_block = local.cidr_anywhere
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" = "PublicRT"
  }
  depends_on = [
    aws_vpc.ntier,
    aws_internet_gateway.igw
  ]
  
}

#creating Private route table
resource "aws_route_table" "privatert" {
  vpc_id = aws_vpc.ntier.id
  tags = {
    "Name" = "PrivateRT"
  }
  depends_on = [
    aws_vpc.ntier
      ]
}

#creating route table association

resource "aws_route_table_association" "associations" {
  count=length(aws_subnet.subnets)
  subnet_id = aws_subnet.subnets[count.index].id
  route_table_id = contains(var.public_subnet_tags,lookup(aws_subnet.subnets[count.index].tags_all,"Name",""))? aws_route_table.publicrt.id: aws_route_table.privatert.id
  
  depends_on = [
    aws_subnet.subnets,
    aws_route_table.privatert,
    aws_route_table.publicrt
  ]
}

