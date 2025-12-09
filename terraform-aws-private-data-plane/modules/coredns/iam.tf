resource "aws_iam_role" "coredns_role" {
  name = "${local.full_name}-coredns-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = local.TAGS
}

resource "aws_iam_instance_profile" "coredns_profile" {
  name = "${local.full_name}-coredns-profile"
  role = aws_iam_role.coredns_role.name
}
