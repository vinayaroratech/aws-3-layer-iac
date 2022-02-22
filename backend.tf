terraform {
  backend "s3" {
    bucket = "symba-tf-state-bucket"
    key    = "tfstate"
    region = "us-east-2"
  }
}