output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.main.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.main.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.main.public_dns
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ${var.key_name}.pem ubuntu@${aws_instance.main.public_ip}"
}

output "key_file" {
  description = "Path to the private key file"
  value       = "${path.module}/${var.key_name}.pem"
}

output "server_url" {
  description = "Spring Boot application URL"
  value       = "http://${aws_instance.main.public_ip}:8080"
}

output "actuator_health_url" {
  description = "Spring Boot actuator health endpoint"
  value       = "http://${aws_instance.main.public_ip}:8080/actuator/health"
}
