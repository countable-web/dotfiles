#!/bin/bash

COMPOSE_ID=${JOB_NAME:-local}

docker-compose -p $COMPOSE_ID ps
docker-compose -p $COMPOSE_ID down

docker-compose -p $COMPOSE_ID up --build

