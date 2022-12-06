variable "name_prefix" {
  description = "Specify a name prefix for the new resources."
  type        = string

  validation {
    condition     = can(regex("[a-zA-Z ]{1,64}", var.name_prefix))
    error_message = "Must be an alphanumeric value including spaces and a max length of 64 characters."
  }
}

variable "region" {
  description = "Specify the AWS region to deploy resources into."
  type        = string

  validation {
    condition     = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.region))
    error_message = "Must be a valid AWS Region name."
  }
}

variable "vpc_id" {
  description = "Specify vpc ID"
  type        = string

  validation {
    condition     = can(regex("[a-zA-Z ]{1,64}", var.vpc_id))
    error_message = "Must be an alphanumeric value including spaces and a max length of 64 characters."
  }
}
