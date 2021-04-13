terraform {
  backend "s3" {
    bucket = "tfa-state"
    key    = "tfstate/be-terraform.tfstate"
    region = "ap-south-1"
  }
}