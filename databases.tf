// Get Password from SSM Parameter Store
data "aws_ssm_parameter" "my_rds_password" {
  name       = "/prod/mysql"
  depends_on = [aws_ssm_parameter.rds_password]
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.db-private_subnets[0].id, aws_subnet.db-private_subnets[1].id]

  tags = {
    Name = "${var.projectname}-Db_subnet_group-${var.env}"
    Owner = "${var.owner}"
    Environment = "${var.env}"
    }
}

resource "aws_db_instance" "default" {
  identifier           = "prod-rds"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_name              = "DB_dev"
  username             = "administrator"
  password             = data.aws_ssm_parameter.my_rds_password.value
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
  db_subnet_group_name = aws_db_subnet_group.default.name
  availability_zone    =  data.aws_availability_zones.available.names[0]
  
  tags = {
    Name = "${var.projectname}-Db_instance-${var.env}"
    Owner = "${var.owner}"
    Environment = "${var.env}"
    
  }
}