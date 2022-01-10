variable "project" {
  description = "The project name"
  type        = string

  # https://github.com/accurics/terrascan/issues/1176
  # nullable = false
}

variable "name" {
  description = "The name"
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
