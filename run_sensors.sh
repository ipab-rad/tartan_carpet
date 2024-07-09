# #!/bin/bash

# Function to handle termination
stop_sensors() {
    echo "Caught signal, stopping Docker Compose..."
    docker compose -f ./sensors_compose.yaml kill
    docker compose -f ./sensors_compose.yaml down
    exit 0
}

# Trap SIGINT and SIGTERM
trap 'stop_sensors' SIGINT SIGTERM

# Start Docker Compose
docker compose -f ./sensors_compose.yaml up &

# Wait for Docker Compose to finish
wait $!

