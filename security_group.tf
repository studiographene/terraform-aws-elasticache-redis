locals {
  enabled                     = module.this.enabled
  create_redis_security_group = local.enabled && var.create_redis_security_group
}


resource "aws_security_group" "redis" {
  name        = "${module.this.id}-redis-sg"
  description = "Controls access to the Redis Cluster"
  vpc_id      = var.vpc_id
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description     = "Allow SGs and cidr to access Redis"
    from_port       = 6379
    to_port         = 6379
    protocol        = "TCP"
    cidr_blocks     = var.redis_ingress_cidr_blocks
    security_groups = var.redis_additional_security_groups

  }
  tags = merge(
    module.this.tags,
    {
      Name = "${module.this.id}-redis-sg"
    },
  )
}

