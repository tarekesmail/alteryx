data "aws_iam_policy_document" "drata_autopilot_assume_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::269135526815:root"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = ["bf64f514-7e1e-48a9-875d-5a44cc4e4875"]
    }
  }
}

resource "aws_iam_role" "drata" {
  name               = "DrataAutopilotRole"
  description        = "Cross-account read-only access for Drata Autopilot"
  assume_role_policy = data.aws_iam_policy_document.drata_autopilot_assume_role.json
}

resource "aws_iam_role_policy_attachment" "security_audit" {
  role       = aws_iam_role.drata.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}