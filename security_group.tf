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
  tags = merge(
    module.this.tags,
    {
      Name = "${module.this.id}-redis-sg"
    },
  )
}

resource "aws_security_group_rule" "ingress_redis" {

  security_group_id = aws_security_group.redis.id
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  cidr_blocks       = var.redis_ingress_cidr_blocks
}

