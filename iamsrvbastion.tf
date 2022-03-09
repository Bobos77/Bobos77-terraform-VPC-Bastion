resource "aws_iam_instance_profile" "bastion-node" {
  name = "${var.env}-bastion-node"
  role = "${aws_iam_role.bastion_role.name}"
}

resource "aws_iam_role" "bastion_role" {
  name               = "${var.env}-bastion-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "bastion_eip_attach_policy" {
  name   = "${var.env}-EIPAttachPolicy"
  role   = "${aws_iam_role.bastion_role.name}"
  policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": [
                  "ec2:AssociateAddress"
              ],
              "Resource": "*"
          }
      ]
}
EOF
}