include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_terragrunt_dir()}/../../../../../modules//api-gateway"
}

dependency "webhook-lambda" {
  config_path = "../webhook-lambda"

  mock_outputs = {
    invoke_arn    = "mocked-arn-for-lambda"
    function_name = "mocked-function-name"
  }

  mock_outputs_allowed_terraform_commands = ["validate", "init", "plan", "show"]

  mock_outputs_merge_strategy_with_state = "shallow"
}

inputs = {
  aws_lambda_webhook_function_invoke_arn = dependency.webhook-lambda.outputs.invoke_arn
  aws_lambda_webhook_function_name       = dependency.webhook-lambda.outputs.function_name
  use_api_key                            = false
}