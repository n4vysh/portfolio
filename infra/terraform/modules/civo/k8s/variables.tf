variable "name" {
  type = string
}

variable "env" {
  type    = string
  default = "default"
}

variable "kubernetes" {
  type = object({
    count   = number
    size    = string
    version = string
  })
}
