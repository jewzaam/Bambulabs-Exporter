#!/usr/bin/env bash

if [ "$1" = "bambulabs-exporter" ]; then
    shift
    exec /app/bambulabs-exporter "$@"
fi

exec "$@"
