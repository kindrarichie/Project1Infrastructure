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

output "webserver-sg-id" {
  value = aws_security_group.server_sg.id
}

output "bastion-sg-id" {
  value = aws_security_group.bastion.id
}