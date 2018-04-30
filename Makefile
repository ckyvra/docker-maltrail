docker_images = maltrail-base maltrail-sensor maltrail-server
tag=0.1

all: lint build

build: $(docker_images)

maltrail-base:
	docker build -t $@:0.1 docker/$@

maltrail-sensor: maltrail-base
	docker build -t $@:$(tag) docker/$@

maltrail-server: maltrail-base
	docker build -t $@:$(tag) docker/$@

compose:
	cd docker
	docker-compose up

lint:
	for docker in $(docker_images); do hadolint docker/$$docker/Dockerfile; done

clean:
	for docker in $(docker_images); do docker rmi -f $$docker:$(tag); done

run-sensor:
	docker run -it maltrail-sensor:$(tag) /bin/bash

run-server:
	docker run -it maltrail-server:$(tag) /bin/bash

