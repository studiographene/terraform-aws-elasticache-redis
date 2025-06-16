
resource "aws_security_group" "redis" {
  name        = "${module.this.id}-redis-sg"
  description = "Controls access to the Redis Cluster"
  vpc_id      = var.vpc_id

  tags = merge(
    module.this.tags,
    {
      Name = "${module.this.id}-redis-sg"
    },
  )
}

resource "aws_security_group_rule" "ingress_security_groups" {
  for_each = toset(var.allowed_security_groups)

  description              = "Allow inbound traffic from existing security groups"
  type                     = "ingress"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "tcp"
  source_security_group_id = each.value
  security_group_id        = join("", aws_security_group.redis.*.id)
}

resource "aws_security_group_rule" "traffic_inside_security_group" {
  count             = var.intra_security_group_traffic_enabled ? 1 : 0
  description       = "Allow traffic between members of the Redis security group"
  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  self              = true
  security_group_id = join("", aws_security_group.redis.*.id)
}

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  count             = length(var.ingress_cidr_blocks) > 0 ? 1 : 0
  description       = "Allow inbound traffic from existing CIDR blocks"
  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = var.ingress_cidr_blocks
  security_group_id = join("", aws_security_group.redis.*.id)
}

resource "aws_security_group_rule" "egress" {
  description       = "Allow outbound traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.redis.*.id)
}
