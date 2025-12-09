resource "null_resource" "download_lambda_zip" {
  count = local.ENABLE_CEFD_SCALING ? 1 : 0

  provisioner "local-exec" {
    command = <<EOT
      mkdir -p /tmp &&
      curl -o /tmp/lambda_function_${local.CLOUD_EXECUTION_LAMBDA_VERSION}.zip https://${local.CEFD_LAMBDA_S3_BUCKET}.s3.amazonaws.com/lambda/cefd-asg-function-${local.CLOUD_EXECUTION_LAMBDA_VERSION}.zip
    EOT
  }
  triggers = {
    build_number = "${timestamp()}"
  }
}

resource "null_resource" "wait_for_file" {
  count      = local.ENABLE_CEFD_SCALING ? 1 : 0
  depends_on = [null_resource.download_lambda_zip]

  provisioner "local-exec" {
    command = <<EOT
      timeout=60
      start_time=$(date +%s)
      while [ ! -f /tmp/lambda_function_${local.CLOUD_EXECUTION_LAMBDA_VERSION}.zip ]; do
        sleep 1
        current_time=$(date +%s)
        elapsed_time=$((current_time - start_time))       
        if [ $elapsed_time -ge $timeout ]; then
          echo "Timeout reached: /tmp/lambda_function_${local.CLOUD_EXECUTION_LAMBDA_VERSION}.zip not found after $timeout seconds."
          exit 1
        fi
      done
    EOT
  }
  triggers = {
    build_number = "${timestamp()}"
  }
}

resource "aws_lambda_function" "kafka_consumer_lambda" {
  count         = local.ENABLE_CEFD_SCALING ? 1 : 0
  function_name = "${var.resource_name}-cefd-asg-lambda-function"
  role          = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.resource_name}-cefd-autoscale-role"
  handler       = "lambda_handler.lambda_handler"
  runtime       = "python3.12"
  filename      = "/tmp/lambda_function_${local.CLOUD_EXECUTION_LAMBDA_VERSION}.zip"
  timeout       = 115

  environment {
    variables = {
      WORKSPACE_PREFIX = var.resource_name
      MAX_CAPACITY     = var.CLOUD_EXECUTION_MAX_SCALING
      REGION           = var.region
    }
  }

  tags = {
    "Version" = local.CLOUD_EXECUTION_LAMBDA_VERSION
  }

  vpc_config {
    subnet_ids         = data.aws_subnets.selected.ids
    security_group_ids = [data.aws_security_group.default.id]
  }

  depends_on = [
    null_resource.download_lambda_zip,
    null_resource.wait_for_file
  ]

}

resource "aws_cloudwatch_event_rule" "cefd_asg_run_1_minute" {
  count               = local.ENABLE_CEFD_SCALING ? 1 : 0
  name                = "${var.resource_name}-cefd-asg-run-1-min"
  schedule_expression = "rate(1 minute)"
}

resource "aws_lambda_permission" "allow_eventbridge_invoke_lambda" {
  count         = local.ENABLE_CEFD_SCALING ? 1 : 0
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.kafka_consumer_lambda[0].arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cefd_asg_run_1_minute[0].arn
}

resource "aws_cloudwatch_event_target" "lambda_trigger" {
  count     = local.ENABLE_CEFD_SCALING ? 1 : 0
  rule      = aws_cloudwatch_event_rule.cefd_asg_run_1_minute[0].name
  target_id = "TargetLambda"
  arn       = aws_lambda_function.kafka_consumer_lambda[0].arn
}
