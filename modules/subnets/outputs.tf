output "public_subnet_ids" { value = ["${aws_subnet.public[*].id}"] }
output "public_subnet_arns" { value = ["${aws_subnet.public[*].arn}"] }
output "private_subnet_ids" { value = ["${aws_subnet.private[*].id}"] }
output "private_subnet_arns" { value = ["${aws_subnet.private[*].arn}"] }
