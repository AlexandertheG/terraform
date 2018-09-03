terraform {
    backend "s3" {
      region = "<s3_region>"
      bucket = "<state_bucket>"
      key = "k-master/terraform.tfstate"
      encrypt = true
      dynamodb_table = "<dynamodb_lock_table>"
    }
}
