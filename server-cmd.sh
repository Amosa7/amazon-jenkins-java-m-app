#!/usr/bin/env bash


docker-compose -f Docker-compose.yaml up --detach

echo "success"

export TEST=testvalue