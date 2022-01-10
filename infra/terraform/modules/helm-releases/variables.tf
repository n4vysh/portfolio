variable "helm" {
  description = "helm release parameters"
  type = list(
    object(
      {
        name       = string
        repository = string
        chart      = string
        version    = string
        namespace  = string
        timeout    = number
        values     = list(string)
      }
    )
  )

  # https://github.com/accurics/terrascan/issues/1176
  # nullable = false
}
