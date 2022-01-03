variable "name" {
  type = string
}

variable "env" {
  type = object({
    short = string
    full  = string
  })
}

variable "domain" {
  type = string
}

variable "policy_actions" {
  type = list(string)
}
