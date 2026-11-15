variable "ssh_cidr" {
  description = "Public IP allowed to SSH into EC2"
  type        = string
  default     = "106.192.68.240/32"
}