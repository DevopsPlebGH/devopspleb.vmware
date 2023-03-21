.PHONY: install_collection

install_collection:
    @docker run --rm \
        -v $(CURDIR):/devopspleb_ansible \
        -w /devopspleb_ansible \
        devopspleb/ansible-vsphere-runner \
        ansible-galaxy install -r requirements.yml
