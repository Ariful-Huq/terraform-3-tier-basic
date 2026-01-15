# S3 Backend Configuration for Terraform State
# This backend stores the Terraform state in an S3 bucket
# Before running terraform init, ensure the S3 bucket exists

terraform {
  backend "s3" {
      bucket  = "ostad08-ariful-terraform-bucket"  # Replace with your S3 bucket name
      key     = "terraform-3-tier-basic/terraform.tfstate"
      region  = "ap-southeast-2"                   # Replace with your region
      profile = "ariful-huq"                       # Replace with your AWS profile

      # Enable encryption
      encrypt = true
    }
}