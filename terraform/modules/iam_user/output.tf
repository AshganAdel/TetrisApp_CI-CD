output "users_name" {
  value = { for k, u in aws_iam_user.users : k => u.name }
}

output "users_arn" {
  value = { for k, u in aws_iam_user.users : k => u.arn }
}

output "group_db" {
  value = aws_iam_group.DB.name
  
}
