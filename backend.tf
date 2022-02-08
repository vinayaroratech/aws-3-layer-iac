terraform {
  backend "s3" {
    bucket = "sybma-terra-state-bucket"
    key    = "tfstate"
    region = "ap-south-1"
  }
}