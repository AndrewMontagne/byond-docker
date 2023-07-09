.PHONY: build sh

sh:
	-docker rm -f byond
	docker run -it --rm --name byond andrewmontagne/byond:514 /bin/bash

build:
	docker pull debian:stable-slim
	docker build . -t andrewmontagne/byond:dev

test:
	docker run -it --rm andrewmontagne/byond:dev bash -c "cd /byond/tests && source /byond/env.sh && /usr/bin/expect /byond/tests/test.expect"