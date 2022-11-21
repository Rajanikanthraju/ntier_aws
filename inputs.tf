variable "target_region" {
    type = string
    default = "ap-southeast-1"
    description = "This region is used to create required AWS infra"  
}
variable "vpc_cidr_range" {
    type = string
    default = "10.10.0.0/16"
    description = "This is vpc cidr range"  
}

variable "subnet_tags" {
    type = list(string)
    default = [ "web1-tf","web2-tf","app1-tf","app2-tf","db1-tf","db2-tf" ]
  
}
variable "s3bucket" {
    type = string
    default = "s3-from-aws-tf"
    description = "this is s3 bucket"
  
}
variable "public_subnet_tags" {
    type = list(string)
    default = [ "web1-tf","web2-tf"]
  
}
variable "db_subnet_tags" {
    type = list(string)
    default = [ "db1-tf","db2-tf"]
  
}
variable "keypath" {
    type = string
    default = "~/.ssh/id_rsa.pub"
  
}

variable "appserverinfo" {
       type = object({
        ami_id             =string
        instance_type      =string
        public_ip_enabled  =bool
        count              =number
        subnets            =list(string)    
        name=string    
        
            })
       default = {
         ami_id ="ami-00e912d13fbb4f225"
         count = 2
         instance_type ="t2.micro"
         public_ip_enabled = false
         subnets = ["app1-tf","app2-tf"] 
         name="appserver"
       }
       
}

variable "webserverinfo" {
       type = object({
        ami_id             =string
        instance_type      =string
        public_ip_enabled  =bool
        count              =number
        subnets            =list(string)    
        name               =string    
        
            })
       default = {
         ami_id ="ami-00e912d13fbb4f225"
         count = 1
         instance_type ="t2.micro"
         public_ip_enabled = true
         subnets = ["web1-tf","web2-tf"] 
         name="webserver"
       }
       
}

variable "incremental" {
    type =string
    default = 0
  
}
