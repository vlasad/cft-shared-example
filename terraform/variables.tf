variable "platform_public_key_path" {}
variable "platform_private_key_path" {}

variable "uuid" {
    description = "Unique prefix for all resources"
}

variable "owner_tag" {
    description = "User email from platform"
}

variable "name_tag" {
    description = "Name of infrastructure from platform"
}

variable "jumpbox_user" {
    default = "ubuntu"
}

variable "root_password" {
    default = "root"
}

variable "docker_image" {
    default = "smatyukevich/training-container"
}

variable "ssh_host" {
    default = "52.14.114.52"
}

variable "docker_host" {
    default = "52.14.114.52"
}

variable "docker_port" {
    default = "2375"
}

variable "external_port" {
    default = "44446"
}

variable "cpu_shares" {
    default = "8"
}

variable "memory" {
    default = "128"
}

variable "cf_domain" {
    default = "34.209.145.208.nip.io"
}

variable "cf_admin" {
    default = "admin"
}

variable "cf_admin_password" {
    default = "688o3x7ggdm92uhpe5eo"
}
