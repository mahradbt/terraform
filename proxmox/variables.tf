variable "proxmox_host" {
  default = "proxmox-host-ip"
}

variable "pm_api_token_id" {
  default = "api-user"
}

variable "pm_node_name" {
  default = "node-name"
}

variable "pm_api_token_secret" {
  sensitive = true
  default = "api-key"
}

variable "cloud_init_template_name" {
  default = "ubuntu-22-cloud"
}

variable "ssh_key" {
  default = "ssh-key"
}