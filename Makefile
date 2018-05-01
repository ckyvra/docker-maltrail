docker_images = maltrail-base maltrail-sensor maltrail-server
tag=0.1

all: lint build

build: $(docker_images)

maltrail-base:
	docker build -t $@:$(tag) docker/$@

maltrail-sensor: maltrail-base
	docker build -t $@:$(tag) docker/$@

maltrail-server: maltrail-base
	docker build -t $@:$(tag) docker/$@

compose:
	cd docker
	docker-compose up

lint: lint-bash lint-docker

lint-docker:
	for docker in $(docker_images); do docker run --rm -i hadolint/hadolint < docker/maltrail-base/Dockerfile; done

lint-bash:
	shellcheck bin/check_ready.sh

clean:
	for docker in $(docker_images); do docker rmi -f $$docker:$(tag); done

run-sensor:
	docker run -it maltrail-sensor:$(tag) /bin/bash

run-server:
	docker run -it maltrail-server:$(tag) /bin/bash

test: test-sensor

test-sensor:
	docker stop maltrail-sensor || true && docker rm maltrail-sensor || true
	docker run --name maltrail-sensor -d maltrail-sensor:0.1
	./bin/check_ready.sh -c maltrail-sensor -s 'more processes' -t 180
	test $$(docker exec maltrail-sensor ls /var/log/maltrail/ | wc -l) -eq 1
	docker exec maltrail-sensor ping -c 1 -W 1 136.161.101.53 || true
	docker exec maltrail-sensor grep -r 136.161.101.53 /var/log/maltrail/
