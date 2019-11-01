# outputs

output "bastion-instance-id" {
  value = aws_instance.Bastion_Host.id
}

output "webserver1-instance-id" {
  value = aws_instance.Webserver1.id
}

output "webserver2-instance-id" {
  value = aws_instance.Webserver2.id
}