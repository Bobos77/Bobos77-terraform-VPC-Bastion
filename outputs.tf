output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "DB-private_subnet_ids" {
  value = aws_subnet.db-private_subnets[*].id
}

output "aws_db_subnet_group_id" {
  value =  aws_db_subnet_group.default.id
}

output "aws_db_instance_id" {
  value =  aws_db_instance.default.id
}

output "webserver_securitygroup_id" {
  value = aws_security_group.webserver.id
}


##output "aws_s3_bucket" {
##  value = aws_s3_bucket.ant-s3bucket-terraform-projects.id
##}
