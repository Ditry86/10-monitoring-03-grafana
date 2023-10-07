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

  metadata = {
  docker-compose = file("docker_compose.yaml")
  user-data = file("cloud_config.yaml")
  ssh-keys = "ditry:${file("~/.ssh/id_ed25519.pub")}"
  }
}