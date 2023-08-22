
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
    from_port       = var.port
    to_port         = var.port
    protocol        = "TCP"
    cidr_blocks     = var.ingress_cidr_blocks
    security_groups = var.allowed_security_groups

  }
  tags = merge(
    module.this.tags,
    {
      Name = "${module.this.id}-redis-sg"
    },
  )
}

