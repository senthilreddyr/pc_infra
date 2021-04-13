terraform {
  backend "s3" {
    bucket = "tfa-state"
    key    = "tfstate/db-terraform.tfstate"
    region = "ap-south-1"
  }
}