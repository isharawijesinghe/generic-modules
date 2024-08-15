data "aws_iam_policy_document" "lambda_assume_role_policy" {
  version = "2012-10-17"
  statement {
    sid = "TrustedRelationships"

    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}


data "aws_iam_policy_document" "lambda_role_policy_document" {
  version = "2012-10-17"

  statement {
    sid    = "AllowReadWriteToLogGroup"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents"
    ]
    resources = [
      "${module.cloudwatch_log_group.arn}:*"
    ]
  }

  statement {
    sid    = "AllowMetricsManagement"
    effect = "Allow"
    actions = [
      "cloudwatch:GetMetricData",
      "cloudwatch:ListMetrics",
      "cloudwatch:PutMetricData"
    ]
    resources = [
      "*"
    ]
    condition {
      test = "StringEquals"
      values = [
        "ST/LambdaHttp",
        "Lambda"
      ]
      variable = "cloudwatch:namespace"
    }
  }

  dynamic "statement" {
    for_each = var.vpc_config == null ? [] : [{}]
    content {
      sid    = "AllowLaunchInVPC"
      effect = "Allow"

      actions = [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
      ]
      resources = ["*"]
    }
  }

  statement {
    sid    = "InvokeSelf"
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction",
    ]
    resources = [
      "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${local.name}:${local.alias_name}"
    ]
  }
}

resource "aws_iam_role" "lambda_role" {
  name                 = "${local.name}-role"
  assume_role_policy   = data.aws_iam_policy_document.lambda_assume_role_policy.json
  tags = var.tags
}

resource "aws_iam_role_policy" "lambda_role_policy" {
  name   = "${local.name}-policy-1"
  policy = data.aws_iam_policy_document.lambda_role_policy_document.json
  role   = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy" "lambda_role_policy_2" {
  count = var.lambda_role_policy_json_enable ? 1 : 0
  role   = aws_iam_role.lambda_role.name
  name   = "${local.name}-policy-2"
  policy = var.lambda_role_policy_json
}