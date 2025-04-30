output "my_s3_bucket_versioning" {  #esto es un valor qe se va a mostrar luego de cada ejecución de terraform apply
    value = aws_s3_bucket.my_s3_bucket.versioning[0].enabled
  }
  
output "my_iam_user_arn" {
    value = aws_iam_user.my_iam_user.arn
}