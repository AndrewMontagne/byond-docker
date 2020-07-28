.PHONY: build sh

sh: build
	-docker rm -f byond
	docker run -it --rm --mount type=bind,source=$(HOME)/dev,target=/code -p3665:3665 --name byond andrewmontagne/byond:latest /bin/bash

build:
	docker build . -t andrewmontagne/byond
