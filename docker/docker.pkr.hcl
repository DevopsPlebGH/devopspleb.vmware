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
  name = "step1"
  source "source.docker.ubuntu" {
    image = "ubuntu:focal"
    commit = true
  }

  provisioner "shell" {
    inline = [
      "echo Installing Python",
      "apt-get update",
      "apt-get install -y python3 python3-pip curl git"
    ]
  }

  provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3"]
    playbook_file    = "./ansible/step1.yml"
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "vmware"
      tags       = ["step1"]
    }
  }
}

build {
  name   = "vmware"
  source "source.docker.ubuntu" {
    image = "vmware:step1"
    commit = true
    pull = false
    changes = [
      "LABEL maintainer='Ralph Brynard <ralph@thebrynards.com>'",
      "WORKDIR /home/linuxbrew",
      "USER linuxbrew",
      "ENV PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
    ]
  }

  provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3"]
    playbook_file    = "./ansible/vmware.yml"
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "vmware"
      tags       = ["1.0.0", "latest"]
    }

    post-processor "docker-tag" {
      repository = "devopspleb/vmware"
      tags       = ["1.0.0", "latest"]
    }

    post-processor "docker-push" {}
  }
}



