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

  dynamic "statement" {
    for_each = length(local.trigger_by_sqs_arns) == 0 ? [] : [{}]
    content {
      sid    = "AllowToConsumeSQS"
      effect = "Allow"
      actions = [
        "sqs:ChangeMessageVisibility",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "sqs:ReceiveMessage",
      ]
      resources = local.trigger_by_sqs_arns
    }
  }

  dynamic "statement" {
    for_each = length(local.kms_decrypt_keys) == 0 ? [] : [{}]
    content {
      sid    = "AllowToDecrypt"
      effect = "Allow"
      actions = [
        "kms:Decrypt",
        "kms:GenerateDataKey*",
      ]
      resources = local.kms_decrypt_keys
    }
  }

}
