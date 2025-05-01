terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Chấp nhận từ 5.0.0 đến 5.x.x, nhưng không lên 6.0.0
    }
  }
}