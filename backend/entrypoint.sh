#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e
# Start the Gunicorn server (or whatever you use)
echo "Starting Gunicorn server..."
poetry run gunicorn score.wsgi:application --bind 0.0.0.0:8000