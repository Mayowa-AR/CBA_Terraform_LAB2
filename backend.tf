terraform {
  backend "s3" {
    bucket         = "myterraform-bucket-amos-arowolo" # Replace with your actual bucket name
    key            = "terraform.tfstate"
    region         = "eu-west-1" # Change to thesame region your bucket was created
    use_lockfile   = true
  }
}