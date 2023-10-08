variable "zone" {
    default="ru-central1-a"
}

output "external_ip_address" {
    value = yandex_compute_instance.vm.network_interface.0.nat_ip_address
}