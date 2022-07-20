output "publicsubnet1_id" {
  description = "publicsubnet1_id"
  value       = aws_subnet.publicsubnet1.id
}
output "publicsubnet2_id" {
  description = "publicsubnet2_id"
  value       = aws_subnet.publicsubnet2.id
}
output "security_group_id" {
  description = "security_group_id"
  value       = aws_security_group.inbound_outbound.id
}