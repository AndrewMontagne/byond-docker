.PHONY: build sh

sh:
	-docker rm -f byond
	docker run -it --rm --name byond andrewmontagne/byond /bin/bash

build:
	docker pull debian:stable-slim
	docker build . -t andrewmontagne/byond

test:
	docker run -it --rm andrewmontagne/byond bash -c "cd /byond/tests && source /byond/env.sh && /usr/bin/expect /byond/tests/test.expect"