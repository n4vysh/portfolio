variable "project" {
  description = "The project name"
  type        = string

  # https://github.com/accurics/terrascan/issues/1176
  # nullable = false
}

variable "domain" {
  description = "The domain name"
  type        = string

  # https://github.com/accurics/terrascan/issues/1176
  # nullable = false
}

variable "env" {
  description = "The environment name"
  type = object({
    short = string
    long  = string
  })

  # https://github.com/accurics/terrascan/issues/1176
  # nullable = false
}

variable "region" {
  description = "The region name"
  type        = string

  # https://github.com/accurics/terrascan/issues/1176
  # nullable = false
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string

  # https://github.com/accurics/terrascan/issues/1176
  # nullable = false
}

variable "subnet_ids" {
  description = "subnet IDs"
  type        = list(string)

  # https://github.com/accurics/terrascan/issues/1176
  # nullable = false
}

variable "bucket_id" {
  description = "The bucket ID"
  type = object({
    lb = string
  })

  # https://github.com/accurics/terrascan/issues/1176
  # nullable = false
}
