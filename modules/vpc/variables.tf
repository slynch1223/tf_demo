variable "cidr" {
  description = "Specify a valid CIDR for new VPC."
  type        = string

  validation {
    condition     = can(cidrhost(var.cidr, 32))
    error_message = "Must use vald CIDR syntax."
  }
}

variable "enable_dns_support" {
  description = "Should dns be enabled."
  type        = bool
  default     = true

  validation {
    condition = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.enable_dns_support))
    error     = "Must be either true or false."
  }
}

variable "instance_tenancy" {
  description = "Define default tenacy for the new VPC."
  type        = string
  default     = "default"

  validation {
    condition     = can(regex("[a-zA-Z ]{1,64}", var.instance_tenancy))
    error_message = "Must be an alphanumeric value including spaces and a max length of 64 characters."
  }
}

variable "region" {
  description = "Specify a name for the new VPC."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("[a-zA-Z ]{1,64}", var.region))
    error_message = "Must be an alphanumeric value including spaces and a max length of 64 characters."
  }
}

variable "vpc_name" {
  description = "Specify a name for the new VPC."
  type        = string

  validation {
    condition     = can(regex("[a-zA-Z ]{1,64}", var.vpc_name))
    error_message = "Must be an alphanumeric value including spaces and a max length of 64 characters."
  }
}
