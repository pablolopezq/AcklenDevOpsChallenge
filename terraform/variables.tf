variable "ansible_user" {
  default = "ubuntu"
}

variable "region" {
  default = "us-east-2"
}

variable "vpc_id" {
  default = "vpc-2193494a"
}

variable "gateway_id" {
  default = "igw-936b2ffb"
}
/*
variable "private_key_one" {
  type = string
  #default = 
}

variable "private_key_two" {
  type = string
  #default = "${file("../keys/instance_two.pem")}"
}
*/
variable "public_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDNBcyBmya/8tSwi8nlchOgJs4vDAybxtKjj5UKOxVWCyUXOlELq5q05sM29mGkzdVovSTDxguZv11A4P+96cjCRRXDyeZg/ea7akBVJjv7cJSE1jT9rmw42TZ88NSApmogl4mjnFidgPISASgu4SbRFIBQQFtfR3Ge8e2J1DTvEiJY6gGUpo5pMpbHgMmaaOx3+KgFXdL+r0JVu61/vh3w+CNE36teQclw2LsuHSQUMSfcKKwQIp96YGD3g3oWhRLv31TnTwXS8kFOUHb6+HcdjhV8UxgYfLO747gBoH5xt1XDh9gvLmd2eHKaQCFRkbb8jB4O/XB9l8CZhAtxGw7J6ce0vXL5Z1Q/+V2S+50WP2aEYoObl7X6dQxg9mzzDjdZenc27JDizxoK9ZFopX2Z4pw32p0AwjuRYkZGSrmNWcHIu9K4d0GWL657wCl5y37pLa+9Qi5lbLFIW9DAOj+W5IiJ6aoFM606M2yQ2ceLMmQS1ks81fys3GmaDRdpsjs= pablo@wall-e"
}

variable "public_key_two" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCxhc/MmYv3vD+VQ93kGLGeWVRD9SvQzLBidu+eRo20X03ex9vIWFvwD4+NzMMRyAZqwKCtvqniXb/nwIFmXyJjn7+WUddkN0HCTC8lxjhxOJxdSofg/7JMlrU1oyzpbW+WWi9BokqqMRKUhMgYWQDycZAq9h2eGasAlT1TPYM727iIoCOMd4AM0pa5bK5G/c7LrivZlqG+f6+ajta2arS+qR0JGBW2wMRTzEgC8iGhMIsW7iNlSpEScs4BBtU7biQeRs4MnCs9a7Ecv6GXAS5yah6UbkYVe1HoNE66YJUNoCL4qdLVPSgzPW/M0CzeLTNxILI1UW4qp9D3C2lDz6fYH0yUAMQMJVMSEJyLOBfQNk0MTgtzz8VUCRpsGDxfwwrpPGy5j0w6e09jmsdFHxDFntVZLnQHMj3c0RRc3htu29+H4t/4N5Dv+9lttQaRwzUUqPiqTqjBmSDHZBKhbRXwizMAIGUUFnK49Vft+UH8e9eOlnUc7wq8tLZy3qgLbSU= pablo@wall-e"
}

variable "subnet_one_block" {
  default = "172.31.150.0/24"
}

variable "subnet_two_block" {
  default = "172.31.100.0/24"
}

variable "zone_one" {
  default = "us-east-2a"
}

variable "zone_two" {
  default = "us-east-2b"
}

variable "image" {
  default = "ami-007e9fbe81cfbf4fa"
}

variable "ec2_type" {
  default = "t2.micro"
}

