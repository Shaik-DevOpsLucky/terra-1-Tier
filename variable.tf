variable "region" {
    default = "ap-south-1"
}


variable "os-name" {
    default = "ami-009e46eef82e25fef"
}


variable "key" {
    default = "mumbai-keypair"
}


variable "instance-type" {
    default = "t2.small"
}


variable "vpc-cidr" {
    default = "10.10.0.0/16"
}

variable "subnet1-cidr" {
    default = "10.10.0.0/24"
}

variable "subnet1-az" {
    default = "ap-south-1a"
}
