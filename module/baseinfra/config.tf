terraform {
  backend "s3" {
    bucket = "tfa-state"
    key    = "tfstate/baseinfra-terraform.tfstate"
    region = "ap-south-1"
  }
}