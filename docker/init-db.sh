#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE DATABASE "$TEST_APP_DATABASE_NAME";
	GRANT ALL PRIVILEGES ON DATABASE "$TEST_APP_DATABASE_NAME" TO "$POSTGRES_USER";
EOSQL