locals {
  ssh_metadata = "${var.ssh_user}:${trimspace(var.ssh_public_key)}"

  common_labels = {
    project = "netology"
    task    = "yandex-cloud-nat"
  }
}
