resource "aws_security_group" "memorydb_sg" {
  name        = "memorydb-security-group"
  description = "Memory DB security group"
  vpc_id      = var.data_plane_vpc_id
  tags        = var.tags
  # Egress rule allowing all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    ignore_changes = [ingress]
  }
}

locals {
  # TODO: use data source instead of hard coding
  memorydb_az = {
    us-east-1      = ["use1-az2", "use1-az4", "use1-az6"],
    us-east-2      = ["use2-az1", "use2-az2", "use2-az3"],
    us-west-1      = ["usw1-az1", "usw1-az2", "usw1-az3"],
    us-west-2      = ["usw2-az1", "usw2-az2", "usw2-az3"],
    ca-central-1   = ["cac1-az1", "cac1-az2", "cac1-az4"],
    ap-east-1      = ["ape1-az1", "ape1-az2", "ape1-az3"],
    ap-south-1     = ["aps1-az1", "aps1-az2", "aps1-az3"],
    ap-northeast-1 = ["apne1-az1", "apne1-az2", "apne1-az4"],
    ap-northeast-2 = ["apne2-az1", "apne2-az2", "apne2-az3"],
    ap-southeast-1 = ["apse1-az1", "apse1-az2", "apse1-az3"],
    ap-southeast-2 = ["apse2-az1", "apse2-az2", "apse2-az3"],
    eu-central-1   = ["euc1-az1", "euc1-az2", "euc1-az3"],
    eu-west-1      = ["euw1-az1", "euw1-az2", "euw1-az3"],
    eu-west-2      = ["euw2-az1", "euw2-az2", "euw2-az3"],
    eu-west-3      = ["euw3-az1", "euw3-az2", "euw3-az3"],
    eu-north-1     = ["eun1-az1", "eun1-az2", "eun1-az3"],
    sa-east-1      = ["sae1-az1", "sae1-az2", "sae1-az3"],
    cn-north-1     = ["cnn1-az1", "cnn1-az2"],
    cn-northwest-1 = ["cnw1-az1", "cnw1-az2", "cnw1-az3"]
  }
}

data "aws_subnets" "memorydb_az_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.data_plane_vpc_id]
  }
  filter {
    name   = "tag:AACSubnet"
    values = ["eks_node"]
  }
}

data "aws_subnet" "memorydb_az_subnet" {
  for_each = { for index, subnet_id in data.aws_subnets.memorydb_az_subnets.ids : index => subnet_id }
  id       = each.value
}

locals {
  subnet_ids = [for subnet in data.aws_subnet.memorydb_az_subnet : subnet.id if contains(local.memorydb_az[var.region], subnet.availability_zone_id)]
}

resource "aws_memorydb_subnet_group" "memorydb_subnet_group" {
  name       = "${var.resource_name}-warmpool-subnetgroup"
  subnet_ids = local.subnet_ids
  tags       = var.tags
}

resource "random_password" "memorydb_password" {
  length  = 16
  special = false
}

resource "aws_memorydb_user" "memorydb_user" {
  user_name     = "${var.resource_name}-warmpool-user"
  access_string = "on ~* &* +@all"

  authentication_mode {
    type      = "password"
    passwords = [random_password.memorydb_password.result]
  }

  tags = var.tags
}

resource "aws_memorydb_acl" "memorydb_acl" {
  name       = "${var.resource_name}-warmpool-acl"
  user_names = [aws_memorydb_user.memorydb_user.user_name]
  tags       = var.tags
}

locals {
  memorydb_port = "6378"
}

resource "aws_memorydb_cluster" "memorydb_cluster" {
  acl_name               = aws_memorydb_acl.memorydb_acl.name
  name                   = "${var.resource_name}-warmpool"
  node_type              = var.memorydb_type
  num_shards             = 1
  subnet_group_name      = aws_memorydb_subnet_group.memorydb_subnet_group.id
  port                   = local.memorydb_port
  num_replicas_per_shard = var.memorydb_replica_per_shard
  security_group_ids     = [aws_security_group.memorydb_sg.id]
  tags                   = var.tags
}

locals {
  secrets = merge(
    local.aac_redis,
    local.aac_warmpool_redis
  )

  clusterMode = var.FUTURAMA_STRUCTURE == "lowers" ? false : true

  aac_redis = {
    "${var.resource_name}-redis" = {
      description = "aws memory db config for redis"
      secret_key_value = jsonencode({
        redisEndpoint = aws_memorydb_cluster.memorydb_cluster.cluster_endpoint[0].address
        redisPort     = aws_memorydb_cluster.memorydb_cluster.port
        redisUser     = aws_memorydb_user.memorydb_user.user_name
        redisPassword = random_password.memorydb_password.result
        clusterMode   = local.clusterMode
      })
    }
  }

  aac_warmpool_redis = {
    "${var.resource_name}-warmpool-redis" = {
      description = "aws memory db config for redis"
      secret_key_value = jsonencode({
        redisEndpoint = aws_memorydb_cluster.memorydb_cluster.cluster_endpoint[0].address
        redisPort     = aws_memorydb_cluster.memorydb_cluster.port
        redisUser     = aws_memorydb_user.memorydb_user.user_name
        redisPassword = random_password.memorydb_password.result
        clusterMode   = local.clusterMode
      })
    }
  }
}

module "data_plane_memorydb_secrets_manager" {
  source                  = "../secrets_manager"
  secrets                 = merge(local.secrets, var.secrets)
  recovery_window_in_days = 0
  tags                    = var.tags
}