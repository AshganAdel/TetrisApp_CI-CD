variable "names" {

    type = map(object({
      name = string
    }))
}
variable "jk_policy_arn" {
  type = string
}

variable "DB_policy_arn" {
  type = string
}

variable "EKS_policy_arn" {
  type = string
}
