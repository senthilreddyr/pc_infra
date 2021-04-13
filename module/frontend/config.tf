terraform {
  backend "s3" {
    bucket = "tfa-state"
    key    = "tfstate/fe-terraform.tfstate"
    region = "ap-south-1"
  }
}