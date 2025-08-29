
#считываем данные об образе ОС
data "yandex_compute_image" "ubuntu_2204_lts" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "alpha" {
  count = 2
  name        = "alpha${count.index}" #Имя ВМ в облачной консоли
  hostname    = "alpha${count.index}" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_a.id #зона ВМ должна совпадать с зоной subnet!!!
    nat                = true
    security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.alpha.id]
  }
}


 # resource "yandex_compute_instance" "web_a" {
  # name        = "web-a" #Имя ВМ в облачной консоли
  # hostname    = "web-a" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  # platform_id = "standard-v3"
  # zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!


  # resources {
    # cores         = 2
    # memory        = 1
    # core_fraction = 20
  # }

  # boot_disk {
    # initialize_params {
      # image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      # type     = "network-hdd"
      # size     = 10
    # }
  # }

  # metadata = {
    # user-data          = file("./cloud-init.yml")
    # serial-port-enable = 1
  # }

  # scheduling_policy { preemptible = true }

  # network_interface {
    # subnet_id          = yandex_vpc_subnet.develop_a.id
    # nat                = false
    # security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.web_sg.id]
  # }
# }

# resource "yandex_compute_instance" "web_b" {
  # name        = "web-b" #Имя ВМ в облачной консоли
  # hostname    = "web-b" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  # platform_id = "standard-v3"
  # zone        = "ru-central1-b" #зона ВМ должна совпадать с зоной subnet!!!

  # resources {
    # cores         = var.test.cores
    # memory        = 1
    # core_fraction = 20
  # }

  # boot_disk {
    # initialize_params {
      # image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      # type     = "network-hdd"
      # size     = 10
    # }
  # }

  # metadata = {
    # user-data          = file("./cloud-init.yml")
    # serial-port-enable = 1
  # }

  # scheduling_policy { preemptible = true }

  # network_interface {
    # subnet_id          = yandex_vpc_subnet.develop_b.id
    # nat                = false
    # security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.web_sg.id]

  # }
# }

# resource "yandex_compute_instance" "wrong_b" {
  # name        = "wrong-hostname" #Имя ВМ в облачной консоли
  # platform_id = "standard-v3"
  # zone        = "ru-central1-b" #зона ВМ должна совпадать с зоной subnet!!!

  # resources {
    # cores         = var.test.cores
    # memory        = 1
    # core_fraction = 20
  # }

  # boot_disk {
    # initialize_params {
      # image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      # type     = "network-hdd"
      # size     = 10
    # }
  # }

  # metadata = {
    # user-data          = file("./cloud-init.yml")
    # serial-port-enable = 1
  # }

  # scheduling_policy { preemptible = true }

  # network_interface {
    # subnet_id          = yandex_vpc_subnet.develop_b.id
    # nat                = false
    # security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.web_sg.id]

  # }
# }


resource "local_file" "inventory" {
  content  = <<-XYZ
  [alpha]
  ${yandex_compute_instance.alpha[0].network_interface.0.nat_ip_address}
  ${yandex_compute_instance.alpha[1].network_interface.0.nat_ip_address}

  XYZ
  filename = "./hosts.ini"
}



