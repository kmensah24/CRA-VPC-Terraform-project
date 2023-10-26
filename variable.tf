variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["10.0.11.0/24", "10.0.12.0/24",]
}
 
variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.0.14.0/24", "10.0.15.0/24",]
}

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["eu-west-2a","eu-west-2b", "u-west-2c"]
}