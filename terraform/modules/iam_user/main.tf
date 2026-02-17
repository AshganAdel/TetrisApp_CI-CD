resource "aws_iam_user" "users" {
  for_each = var.names

  name = each.value.name

  tags = {
    tag-key = each.value.name
  }
}

// EKS group & attach user to this group
resource "aws_iam_group" "EKS" {
  name = "EKS_TEAM"
}

resource "aws_iam_group_membership" "EKS_team" {
  name = "EKS_team"
  users =  [aws_iam_user.users["eks_user"].name]  
  group = aws_iam_group.EKS.name
}

// jenkins group & attach user to this group
resource "aws_iam_group" "jenkins" {
  name = "JK_TEAM"
}

resource "aws_iam_group_membership" "JEN_team" {
  name = "JK_team"
  users =  [aws_iam_user.users["jen_user"].name] 
  group = aws_iam_group.jenkins.name
}

resource "aws_iam_group_policy_attachment" "EKS_policy" {
  group      = aws_iam_group.EKS.name
  policy_arn = var.EKS_policy_arn
}

resource "aws_iam_group_policy_attachment" "jk_policy" {
  group      = aws_iam_group.jenkins.name
  policy_arn = var.jk_policy_arn
}