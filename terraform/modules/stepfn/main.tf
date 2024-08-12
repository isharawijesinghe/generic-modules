resource "aws_sfn_state_machine" "state_machine" {
  name     = "${var.function_name}-state-machine-${var.environment}"
  role_arn = aws_iam_role.sfn_role.arn
  type     = "STANDARD"
  definition = var.definition
}

resource "aws_iam_role" "sfn_role" {
  name = "sfn_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "states.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "sfn_policy" {
  role       = aws_iam_role.sfn_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess"
}

resource "aws_iam_role_policy" "sfn_lambda_invoke_policy" {
  name   = "sfn_lambda_invoke_policy"
  role   = aws_iam_role.sfn_role.id
 // policy = data.aws_iam_policy_document.sfn_lambda_invoke_policy.json
  policy = var.sfn_lambda_invoke_policy
}
