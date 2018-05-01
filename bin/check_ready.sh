#!/usr/bin/env bash

set -eu

usage() {
    program_name="$(basename "$0")"
    echo "Usage: \"$program_name\" [-h] -c container -t timeout -s string" 1>&2
}

# String to search in log to detect docker container is ready
started_string=""

# Maximum number of seconds to wait for docker container being ready
timeout=4

docker_name=""
while getopts "hs:t:c:" option; do
    case "${option}" in
        c)   docker_name=${OPTARG} ;;
        s)   started_string=${OPTARG} ;;
        t)   timeout=${OPTARG} ;;
        h|*) usage
             exit 1 ;;
    esac
done
shift $((OPTIND - 1))

if ! [ "$docker_name" ]; then
    usage
    echo "No container set" 1>&2
    exit 1
fi

if ! [ "$started_string" ]; then
    usage
    echo "No string set" 1>&2
    exit 1
fi

# Check if the docker container is started based on docker container logs
is_started() {
   docker logs "$docker_name" | grep -q "$started_string"
}

# Exit if docker container does not exist
docker logs "$docker_name" > /dev/null

# Detect if the process is started in less than "timeout" seconds
echo -n "Checking readiness"
declare -i i=0;
while true; do
    is_started && break;
    sleep 1;
    i+=1
    echo -n .
    if [[ $i -ge $timeout ]]; then break; fi
done

# Display results
echo
if is_started; then
    echo "Container ready"
else
    echo "Container not ready"
    exit 1
fi
