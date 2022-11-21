resource "aws_key_pair" "keypair" {
    key_name="keyfromtf"
    public_key = file("~/.ssh/id_rsa.pub")
  
}

/*
resource "aws_instance" "appservers" {
  count =var.appserverinfo.count
  ami  = var.appserverinfo.ami_id
  instance_type = var.appserverinfo.instance_type
  key_name = aws_key_pair.keypair.key_name
  vpc_security_group_ids = [aws_security_group.appsg.id]
  associate_public_ip_address = var.appserverinfo.public_ip_enabled
  subnet_id = data.aws_subnets.appsubnets.ids[count.index]
  tags = {
   "Name" = format("%s-%d",var.appserverinfo.name,count.index+1)
 }
 
  
}*/
resource "aws_instance" "webservers" {
  count =var.webserverinfo.count
  ami  = var.webserverinfo.ami_id
  instance_type = var.webserverinfo.instance_type
  key_name = aws_key_pair.keypair.key_name
  vpc_security_group_ids = [aws_security_group.websg.id]
  associate_public_ip_address = var.webserverinfo.public_ip_enabled
  subnet_id = data.aws_subnets.websubnets.ids[count.index]
  tags = {
   "Name" = format("%s-%d",var.webserverinfo.name,1)
 }
 
   
  
}

resource "null_resource" "forprovisioning" {
count =var.webserverinfo.count

triggers = {
  "execute" = var.incremental
}
connection {
    type="ssh"
    user="ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host= aws_instance.webservers[count.index].public_ip
  }
 provisioner "remote-exec" {
    inline = [
      "#!/bin/bash",
      "sudo apt update",
      "sudo apt install apache2 -y",
      "sudo apt install openjdk-11-jdk -y"
        ]
  }  
  
}