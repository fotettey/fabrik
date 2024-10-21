#!/bin/bash
set -e

## https://hub.docker.com/_/postgres

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE USER sonarqube WITH PASSWORD 'sonarqube';
	CREATE DATABASE sonarqube;
	GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonarqube;
EOSQL
