resource "yandex_compute_instance" "vm" {
  name = "vm"
  zone=var.zone
  resources {
    cores  = 8
    memory = 16
  } 

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.container-optimized-image.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.test_subnet.id
    ipv4 = true
    ip_address = "192.168.10.10"
    nat = true
  }

  allow_stopping_for_update = true

  connection {
    type     = "ssh"
    user     = "ditry"
    private_key = file("~/.ssh/id_ed25519")
    host = self.network_interface.0.nat_ip_address
    #host = yandex_compute_instance.vm.network_interface.0.nat_ip_address
  }
  
  provisioner "remote-exec" {
    inline = [
	  "sudo mkdir /tmp/prometheus",
    "sudo chmod a+rw /tmp/prometheus",
    ]
  }
  
  provisioner "file" {
    source      = "./prometheus/prometheus.yml"
    destination = "/tmp/prometheus/prometheus.yml"
  } 

  metadata = {
  docker-compose = file("docker_compose.yml")
  user-data = file("cloud_config.yml")
  ssh-keys = "ditry:${file("~/.ssh/id_ed25519.pub")}"
  }
}
