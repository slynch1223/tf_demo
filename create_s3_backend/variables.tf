variable "environment" {
  description = "Specify an environment for the current deployment."
  type        = string

  validation {
    condition     = can(regex("[0-9a-z]{1,10}", var.environment))
    error_message = "Must be either 'dev' or 'prd' in only lower case letters."
  }
}

variable "region" {
  description = "Specify the AWS region to deploy resources into."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.region))
    error_message = "Must be a valid AWS Region name."
  }
}
