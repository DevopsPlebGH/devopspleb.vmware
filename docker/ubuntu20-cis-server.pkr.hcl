packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {}

build {
  name = "phase1"
  source "source.docker.ubuntu" {
    image = "ubuntu:focal"
    commit = true
    changes = [
      "LABEL org.devopspleb.image.source='CIS Ubuntu Linux 20.04 LTS Benchmark v1.0.0 - Level 1 - Server'"
    ]
  }

  provisioner "shell" {
    inline = [
      "apt-get update",
      "apt-get install -y python3 python3-pip"
    ]
  }

  provisioner "ansible" {
    ansible_env_vars = [
      "ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3"
    ]
    playbook_file = "./ansible/playbooks/phase1.yml"
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "ubuntu20-cis-server"
      tags = ["phase1"]
    }
  }
}

build {
  name = "phase2"
  source "source.docker.ubuntu" {
    image = "ubuntu20-cis-server:phase1"
    commit = true
    pull = false
    changes = [
      "WORKDIR /home/linuxbrew",
      "USER linuxbrew",
      "ENV PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH",
      "ENV HOMEBREW_NO_AUTO_UPDATE=1",
      "ENV HOMEBREW_NO_ANALYTICS=1"
    ]
  }

  provisioner "ansible" {
    ansible_env_vars = [
      "ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3"
    ]
    playbook_file = "./ansible/playbooks/phase2.yml"
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "ubuntu20-cis-server"
      tags = ["1.0.0", "latest"]
    }
  }

  post-processor "manifest" {
    output              = "./ansible/manifests/ubuntu20-cis-server.json"
    strip_path          = true
  }
}