variable "env" {
  description = "The environment name"
  type = object({
    short = string
    long  = string
  })

  # https://github.com/accurics/terrascan/issues/1176
  # nullable = false
}

variable "github_owner" {
  type        = string
  description = "github owner"

  # https://github.com/accurics/terrascan/issues/1176
  # nullable = false
}

variable "repository_name" {
  type        = string
  description = "github repository name"

  # https://github.com/accurics/terrascan/issues/1176
  # nullable = false
}

variable "branch" {
  type        = string
  default     = "main"
  description = "branch name"

  # https://github.com/accurics/terrascan/issues/1176
  # nullable = true
}

variable "target_path" {
  type        = string
  description = "flux sync target path"

  # https://github.com/accurics/terrascan/issues/1176
  # nullable = false
}
