output "instance_public_ip" {
  value = aws_instance.devops_node.public_ip
}

output "s3_bucket_name" {
  value = aws_s3_bucket.lab_bucket.id
}
