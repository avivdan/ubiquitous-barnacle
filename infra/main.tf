terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket  = "project-4-terraform-bucket"
    key     = "task4/terraform.tfstate"
    region  = "eu-north-1"
    encrypt = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  token = var.github_token
}
