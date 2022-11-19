variable "cidr" {
  description = "Specify a valid CIDR for new VPC."
  type        = string
  // Need Validation
}

variable "name" {
  description = "Specify a name for the new VPC."
  type        = string
  // Need Validation
}
