provider "docker" {
    host = "${var.docker_host}:${var.docker_port}"
}

resource "docker_image" "ubuntu" {
    name = "${var.docker_image}"
}

resource "docker_container" "training_container" {
    image = "${docker_image.ubuntu.latest}"
    memory = "${var.memory}"
    cpu_shares = "${var.cpu_shares}"
    name = "cf-training-${var.uuid}"
    command = ["bash", "-c", "/usr/sbin/sshd; tail -f /dev/null"]

    ports {
        internal = 22
        external = "${var.external_port}"
    }

    connection {
        host = "${var.docker_host}"
        user = "root"
        port = "${var.external_port}"
        password = "${var.root_password}"
    }

    provisioner "local-exec" {
        command = "${path.module}/scripts/local.sh"
    }

    provisioner "file" {
        source = "${var.platform_public_key_path}"
        destination = "/home/${var.jumpbox_user}/.ssh/authorized_keys"
    }

    provisioner "file" {
        source = "${path.module}/scripts/check.sh"
        destination = "/home/${var.jumpbox_user}/check.sh"
    }

    provisioner "file" {
        source = "${path.module}/scripts/run.sh"
        destination = "/home/${var.jumpbox_user}/run.sh"
    }

    provisioner "remote-exec" {
        inline = [ "chmod +x /home/${var.jumpbox_user}/check.sh",
                   "chmod +x /home/${var.jumpbox_user}/run.sh",
                   "chown ${var.jumpbox_user} /home/${var.jumpbox_user}/.ssh/authorized_keys",
                   "chmod 600 /home/${var.jumpbox_user}/.ssh/authorized_keys",
                   "sh /home/${var.jumpbox_user}/check.sh",
                   "sh -c '/home/${var.jumpbox_user}/run.sh ${var.cf_domain} ${var.owner_tag} ${var.uuid}'"]
    }
}

output "jumpbox_ip" {
  value = "${var.ssh_host}"
}

output "jumpbox_user" {
  value = "${var.jumpbox_user}"
}

output "ssh_port" {
  value = "${var.external_port}"
}
