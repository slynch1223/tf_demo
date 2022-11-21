variable "target-az" {
  description = "Specify a target Availabilty Zone (az)"
  type        = string
}

variable "cidr" {
  description = "Specify a valid CIDR for new VPC."
  type        = string
}

variable "name" {
  description = "Specify a name for the new VPC."
  type        = string
}
