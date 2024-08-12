resource "aws_security_group" "dev_egress" {
  count = terraform.workspace == "default" ? 0 : (var.vpc_config != null ? 1 : 0)

  name   = "${local.name}-dev-egress-sg"
  vpc_id = var.vpc_config.vpc_id

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

resource "aws_security_group_rule" "egress_to_dd_apm_ipv4" {
  count = var.datadog_agent_config.apm == true && var.vpc_config != null ? 1 : 0

  description       = "Allow Egress to Datadog APM endpoint CIDRs"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = data.datadog_ip_ranges.map.apm_ipv4
  security_group_id = var.vpc_config.security_group_id
}