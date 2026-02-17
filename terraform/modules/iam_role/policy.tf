resource "aws_iam_policy" "EKS_policy" {
  name        = "EKS_policy"
  description = "EKS policy"
  policy = jsonencode({ 
    
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "EKSFullAccess",
            "Effect": "Allow",
            "Action": [
                "eks:ListClusters",
                "eks:DescribeCluster",
                "eks:ListUpdates",
                "eks:DescribeUpdate",
                "eks:CreateCluster",
                "eks:UpdateClusterConfig",
                "eks:UpdateClusterVersion",
                "eks:DeleteCluster",
                "eks:CreateFargateProfile",
                "eks:DeleteFargateProfile",
                "eks:CreateNodegroup",
                "eks:DeleteNodegroup",
                "eks:UpdateNodegroupConfig",
                "eks:UpdateNodegroupVersion"
            ],
            "Resource":"*" //var.EKS_ARN_resource

    }
        ]

  })
}


resource "aws_iam_policy" "EC2_policy" {
  name        = "EC2_policy"
  description = "EC2 policy"
  policy = jsonencode({ 
    
  "Version": "2012-10-17",
  "Statement": [
    {
         "Sid": "EC2FullAccess",
            "Effect": "Allow",
            "Action": "ec2:*",
            "Resource": "*"//var.EC2_ARN_resource

    }
        ]

  })
}

// create EKS role and attach this role to EKS policy
resource "aws_iam_role" "EKS_role" {
  name = "EKS_role"
  assume_role_policy = jsonencode({
  Version = "2012-10-17",
  Statement = [
    {
      Effect = "Allow",
      Principal = {
        AWS = var.EKS_user_arn
      },
      Action = "sts:AssumeRole"
    }
  ]
})
}

resource "aws_iam_role_policy_attachment" "EKS_" {
  role       = aws_iam_role.EKS_role.name
  policy_arn = aws_iam_policy.EKS_policy.arn
  
}

// create JEn role and attach this role to EC2 policy
resource "aws_iam_role" "JEN_role" {
  name = "JEN_role"
  assume_role_policy = jsonencode({
  Version = "2012-10-17",
  Statement = [
    {
      Effect = "Allow",
      Principal = {
        AWS = var.JEN_user_arn
      },
      Action = "sts:AssumeRole"
    }
  ]
})
}

resource "aws_iam_role_policy_attachment" "JEN_" {
  role       = aws_iam_role.JEN_role.name
  policy_arn = aws_iam_policy.EC2_policy.arn
  
}