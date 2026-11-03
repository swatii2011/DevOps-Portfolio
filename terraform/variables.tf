variable "ssh_cidr" {
  description = "Public IP allowed to SSH into EC2"
  type        = string
  default     = "106.192.70.46/32"
}