
output "ec2_public_ip" {
  description = "Static public IP address of the portfolio EC2 instance"
  value       = aws_eip.portfolio.public_ip
}

output "website_url" {
  description = "Portfolio website URL"
  value       = "http://${aws_eip.portfolio.public_ip}"
}
