#!/bin/sh
set -e

# Create directories if they don't exist
mkdir -p /app/uploads /app/cache

# Start the application
if [ -f "./server.js" ]; then
  echo "Starting with standalone server..."
  exec node ./server.js
else
  echo "Starting with npm start..."
  exec npm start
fi

