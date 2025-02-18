provider "proxmox" {
  pm_api_url = "https://${var.proxmox_host}:8006/api2/json"
  pm_api_token_id = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure = true  # Only if using self-signed cert
}

resource "proxmox_vm_qemu" "k8s_master" {
  name        = "k8s-master"
  target_node = var.pm_node_name
  clone       = var.cloud_init_template_name
  full_clone  = true
  agent       = 1

  # Hardware specs
  cores   = 2
  memory  = 4096
  scsihw  = "virtio-scsi-single"

  onboot = true
  automatic_reboot = false

  disk {
    slot    = "scsi0"
    size    = "20G"
    type    = "disk"
    storage = "local-lvm"
    discard = true
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
    firewall = false
    link_down = false
  }

  # Cloud-Init Configuration
  os_type = "cloud-init"
  ipconfig0 = "ip=192.168.1.200/24,gw=192.168.168.1"
  ciuser     = "ansible"
  sshkeys = var.ssh_key
}

resource "proxmox_vm_qemu" "k8s_worker" {
  count       = 1
  name        = "k8s-worker-${count.index + 1}"
  target_node = var.pm_node_name
  clone       = var.cloud_init_template_name
  full_clone  = true
  agent       = 1

  cores   = 4
  memory  = 8192
  scsihw  = "virtio-scsi-single"

  onboot = true
  automatic_reboot = false

  disk {
    slot    = "scsi0"
    size    = "40G"
    type    = "disk"
    storage = "local-lvm"
    discard = true
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
    firewall = false
    link_down = false
  }

  os_type = "cloud-init"
  ipconfig0 = "ip=192.168.1.20${count.index + 1}/24,gw=192.168.168.1"
  ciuser     = "ansible"
  sshkeys = var.ssh_key
}