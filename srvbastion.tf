data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}




resource "aws_launch_configuration" "bastion_lc" {
  associate_public_ip_address = true
  image_id                    = "${data.aws_ami.latest_amazon_linux.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.bastion-node.name}"
  instance_type               = "${var.instance_type}"
  name_prefix                 = "bastion"
  security_groups             = ["${aws_security_group.bastion.id}"]
  key_name                    = "${var.key_pair_name}"
  
  lifecycle {
    create_before_destroy = true
  }
  user_data = templatefile("user_data.sh", {
    eip    = "${aws_eip.bastion.id}",
    region = "${var.region}"
  })
}

resource "aws_autoscaling_group" "bastion_asg" {
  desired_capacity     = "1"
  launch_configuration = "${aws_launch_configuration.bastion_lc.name}"
  max_size             = "1"
  min_size             = "1"
  default_cooldown     = "0"
  name                 = "${var.env}"
  vpc_zone_identifier  = aws_subnet.public_subnets[*].id
  
 }