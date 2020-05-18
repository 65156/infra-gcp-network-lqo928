terraform {
  backend "s3" {
    # Amazon S3 & DynamoDB Backend Configuration for Terraform State Locking
    bucket         = "terraform-state-827389"
    key            = "infrastructure/infra-gcp-core.tfstate"
    dynamodb_table = "terraform-remote-lock-state"
    region         = "ap-southeast-2"
    #encrypt = true # Server Side Encryption
  }
}