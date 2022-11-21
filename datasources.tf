data "aws_subnets" "dbsubnets" {
    filter {
       name="tag:Name"
       values = var.db_subnet_tags
    }
    filter {
      name="vpc-id"
      values = [aws_vpc.ntier.id]
    }
  depends_on = [
    aws_subnet.subnets
  ]
}
data "aws_subnets" "appsubnets" {
    filter {
       name="tag:Name"
       values = var.appserverinfo.subnets
    }
    filter {
      name="vpc-id"
      values = [aws_vpc.ntier.id]
    }
  depends_on = [
    aws_key_pair.keypair
  ]
}

data "aws_subnets" "websubnets" {
    filter {
       name="tag:Name"
       values = var.webserverinfo.subnets
    }
    filter {
      name="vpc-id"
      values = [aws_vpc.ntier.id]
    }
  depends_on = [
    aws_key_pair.keypair
  ]
}