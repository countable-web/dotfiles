#!/bin/bash

docker compose exec django python manage.py clearsessions
docker compose exec db psql -U postgres postgres -c "VACUUM FULL VERBOSE;"
