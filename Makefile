.PHONY: build sh

sh:
	-docker rm -f byond
	docker run -it --rm --name byond andrewmontagne/byond:latest /bin/bash

build:
	docker build . --squash -t andrewmontagne/byond
