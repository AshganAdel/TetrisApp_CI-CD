output "DB_policy_arn" {
  value = aws_iam_policy.RDS_policy.arn
}

output "EKS_policy_arn" {
    value = aws_iam_policy.EKS_policy.arn
  
}

output "jk_policy_arn" {
    value = aws_iam_policy.EC2_policy.arn
  
}