variable "lambda_logs_retention" {
  type = number
}
output "invoke_arn" {
  value = aws_lambda_function.validate_token_lambda.invoke_arn
}
