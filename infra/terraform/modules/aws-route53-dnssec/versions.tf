terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 4.2.0"
      configuration_aliases = [aws.us_east_1]
    }
  }

  required_version = "~> 1.1.2"
}