output "arn" { value = aws_vpc.this.arn }
output "id" { value = aws_vpc.this.id }
output "nacl_id" { value = aws_vpc.this.default_network_acl_id }
output "route_table_id" { value = aws_vpc.this.default_route_table_id }
output "security_group_id" { value = aws_vpc.this.default_security_group_id }
output "internet_getway_id" { value = aws_internet_gateway.this.id }
output "internet_getway_arn" { value = aws_internet_gateway.this.arn }
