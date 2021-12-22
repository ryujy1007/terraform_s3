provider "aws" {
  region = "ap-northeast-2"
}


resource "aws_s3_bucket" "btc-state-file-bucket" {
  bucket = "terraform-up-and-running-state7"
  /* acl = "private"
  force_destroy = false */

  #id = "co777-s3"
  /* arn = ""
  #acceleration_status = ""
  bucket_domain_name = ""
  bucket_regional_domain_name = ""
  hosted_zone_id =""
  region = ""
  request_payer = ""
  acceleration_status = ""
  website_domain = ""
  website_endpoint = "" */


  tags = {
    Name = "btc-state-file-2bucket"
  }

  lifecycle {
    prevent_destroy =true
  }

  versioning {
    enabled = true
  #  mfa_delete = ""
  }

  #Logging
  /* logging {
    target_bucket = aws_s3_bucket.ryujystate.id
    target_prefix = "log/"
  } */

   server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  } 
}


#dynamodb
resource "aws_dynamodb_table" "terraform_locks" {
  name = "terraform-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}


