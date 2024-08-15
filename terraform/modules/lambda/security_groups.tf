resource "aws_security_group" "dev_egress" {
  count = terraform.workspace == "default" ? 0 : (var.vpc_config != null ? 1 : 0)

  name   = "${local.name}-dev-egress-sg"
  vpc_id = var.vpc_config.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]

    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "Dev-only egress to avoid provisioning VPC Endpoints."
  }
}

