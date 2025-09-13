#!/bin/bash
# Function allows calling a locally installed r2r repo from any location, with configs/env/secrets defined at that location.
# function can be called and passed normal docker compose commands:
# Examples: ./r2rme.sh up
# Examples: ./r2rme.sh down -v --remove-orphans
# Function needs to have the below variablles exported: 
#EXPORT absolute directories
# R2R_CONFIG_DIR is the folder that is logical equivalent of r2r/docker/user_configs 
R2R_CONFIG_DIR="/home/peter/development/projects/r2r-py-introspection/r2r_config/user_configs"
# export R2R_CONFIG_DIR=$R2R_CONFIG_DIR
# ENV_DIR is the folder that is logical equivalent of r2r/docker/env 
ENV_DIR="/home/peter/development/projects/r2r-py-introspection/r2r_config/env"
# export ENV_DIR=$ENV_DIR
# SECRETS_DIR is the folder that contains docker secret style files (file named for the var name)
SECRETS_DIR="/home/peter/secrets"
# export SECRETS_DIR=$SECRETS_DIR
#name for the docker network this compose runs in, and the prefix for its volumes
COMPOSE_NETWORK="r2r-py-introspection"
# export COMPOSE_NETWORK=$COMPOSE_NETWORK

#Not super sensitive secrets...

# development/projects/r2r/docker/env/r2r.env
  # R2R_POSTGRES_PASSWORD=postgres
  # export R2R_POSTGRES_PASSWORD=$(cat $SECRETS_DIR/R2R_POSTGRES_PASSWORD)
# development/projects/r2r/docker/env/postgres.env
  # POSTGRES_PASSWORD=postgres
  # export POSTGRES_PASSWORD=$(cat $SECRETS_DIR/POSTGRES_PASSWORD)
# development/projects/r2r/docker/env/minio.env
  # MINIO_ROOT_PASSWORD=minioadmin
  # export MINIO_ROOT_PASSWORD=$(cat $SECRETS_DIR/MINIO_ROOT_PASSWORD)
# development/projects/r2r/docker/env/hatchet.env
  # DATABASE_POSTGRES_PASSWORD=hatchet_password
  # export DATABASE_POSTGRES_PASSWORD=$(cat $SECRETS_DIR/DATABASE_POSTGRES_PASSWORD)
  # POSTGRES_PASSWORD=hatchet_password
  # export POSTGRES_PASSWORD=$(cat $SECRETS_DIR/POSTGRES_PASSWORD)
  # SERVER_TASKQUEUE_RABBITMQ_URL=amqp://user:password@hatchet-rabbitmq:5672/
  # export SERVER_TASKQUEUE_RABBITMQ_URL=$(cat $SECRETS_DIR/SERVER_TASKQUEUE_RABBITMQ_URL)
  # RABBITMQ_DEFAULT_PASS=password
  # export RABBITMQ_DEFAULT_PASS=$(cat $SECRETS_DIR/RABBITMQ_DEFAULT_PASS)
  # DATABASE_URL="postgres://hatchet_user:hatchet_password@hatchet-postgres:5432/hatchet?sslmode=disable"
  # export DATABASE_URL=$(cat $SECRETS_DIR/DATABASE_URL)
# development/projects/r2r/docker/env/r2r-dashboard.env
# export NEXT_PUBLIC_R2R_DEFAULT_EMAIL=$(cat $SECRETS_DIR/next_public_r2r_default_email)
# export NEXT_PUBLIC_R2R_DEFAULT_PASSWORD=$(cat $SECRETS_DIR/next_public_r2r_default_password)

#this profile is needed for the compose to work.
export COMPOSE_PROFILES="postgres"
#the project directory should point to the location of the r2r repo's docker folder
docker compose --project-directory /home/peter/development/projects/r2r/docker \
  --project-name "r2r_introspection" \
  -e R2R_CONFIG_DIR="${R2R_CONFIG_DIR}" \
  -e ENV_DIR="${ENV_DIR}" \
  -e SECRETS_DIR="${SECRETS_DIR}" \
  -e COMPOSE_NETWORK="${COMPOSE_NETWORK}" \
  -e NEXT_PUBLIC_R2R_DEFAULT_EMAIL="${NEXT_PUBLIC_R2R_DEFAULT_EMAIL}" \
  -e NEXT_PUBLIC_R2R_DEFAULT_PASSWORD="${NEXT_PUBLIC_R2R_DEFAULT_PASSWORD}" \
  -f /home/peter/development/projects/r2r/docker/compose.full.with-secrets.yaml \
  "$@"
