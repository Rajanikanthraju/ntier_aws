resource "aws_db_subnet_group" "db_subnet_group" {
  name = "db_subnet_group"
  subnet_ids = data.aws_subnets.dbsubnets.ids

  tags = {
    "Name" = "DbSubnetGroup"
  }
  depends_on = [
    aws_subnet.subnets,
    aws_vpc.ntier
  ]
}

/*
resource "aws_db_instance" "db_instance" {
  allocated_storage    = 20
  db_name              = "mydbinstance"
  engine               = "mysql"
  engine_version       = "8.0.31"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "admin123"
  skip_final_snapshot  = true
  identifier = "dbinstancefromtf"
  depends_on = [
    aws_db_subnet_group.db_subnet_group
  ]
} */