.PHONY: docker_build

docker_build:
	@docker build \
		-t ansible:$(version) .

docker_run:
	@docker run \
		-it ansible:$(version) \
		/bin/bash
