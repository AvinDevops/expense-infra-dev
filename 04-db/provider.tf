terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.62.0"
        }
    }
    backend "s3" {
        bucket = "avin-remote-state"
        key = "expense-dev-db"
        region = "us-east-1"
        dynamodb_table = "daws78s-locking"
    }
}

provider "aws" {
    region = "us-east-1"
}