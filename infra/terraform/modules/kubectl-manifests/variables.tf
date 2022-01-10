variable "yaml" {
  description = "kubernetes manifests"
  type = list(
    object(
      {
        name    = string
        content = string
      }
    )
  )

  # https://github.com/accurics/terrascan/issues/1176
  # nullable = false
}
