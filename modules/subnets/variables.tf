variable "availability_zone" {
  description = "Specify a target Availabilty Zone (az)"
  type        = string
}

variable "cidr" {
  description = "Specify a valid CIDR for new subnet."
  type        = string
}

variable "subnet_name" {
  description = "Specify a name for the new subnet."
  type        = string
}

variable "vpc_id" {
  description = "Specify vpc ID"
  type        = string
}
