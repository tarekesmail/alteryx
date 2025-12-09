locals {
  teleport_agent_base_ami_name = "al2023-ami-2*kernel-6.1*"
  teleport_agent_base_ami      = data.aws_ami.teleport_agent_base_ami.id
}

data "aws_ami" "teleport_agent_base_ami" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = [local.teleport_agent_base_ami_name]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "hypervisor"
    values = ["xen"]
  }
}