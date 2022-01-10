variable "cluster_id" {
  description = "The cluter identifier"
  type        = string
  nullable    = false
}

variable "cluster_endpoint" {
  description = "The cluter endpoint"
  type        = string
  nullable    = false
}

variable "cluster_ca_cert" {
  description = "The cluter certificate authority data"
  type        = string
  nullable    = false
}
