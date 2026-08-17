output "lambda_arn" {
  value = aws_lambda_function.iam_monitor.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.iam_monitor.function_name
}