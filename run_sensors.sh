#!/bin/bash

help() {
    echo "Usage: run_sensors.sh [options] [sensor_list]
    
    Options:
      --dev        Use the 'dev_sensors_compose.yaml' file
      --build      Build Docker images for the specified sensors (only valid with --dev)
      -h, --help   Show this help message and exit
    "
    exit 0
}


# Function to handle termination
stop_sensors() {
    echo "Caught signal, stopping Docker Compose..."
    docker compose -f "$compose_file" kill
    docker compose -f "$compose_file" down
    exit 0
}

# Trap SIGINT and SIGTERM
trap 'stop_sensors' SIGINT SIGTERM

# Default values
compose_file="./sensors_compose.yaml"
services=""
build_docker=""
is_dev_mode="false"

while [[ $# -gt 0 ]]; do
    case $1 in
        --dev)
            compose_file="./dev_sensors_compose.yaml"
            is_dev_mode="true"
            shift
            ;;
        --build)
            build_docker="True"
            shift
            ;;
        -h|--help)
            help
            ;;
        *)
            services="$services $1"
            shift
            ;;
    esac
done

build_docker_images() {
    original_dir=$(pwd)  # Save the original directory
    for service in $services; do
        found=0
        # Search recursively for directories matching the service name
        for dir in $(find . -type d -name "$service"); do
            # Check for Dockerfile in the directory
            if [[ -f "$dir/Dockerfile" ]]; then
                echo "Building Docker image for $service..."
                pushd "$dir" > /dev/null   # Change to the directory containing the Dockerfile
                docker build -t "$service:latest" --target runtime .
                popd > /dev/null   # Return to the original directory
                found=1
                break
            fi
        done
        # If no matching Dockerfile or directory is found
        if [[ $found -eq 0 ]]; then
            echo "No directory or Dockerfile found for $service."
        fi
    done
}

# Only build Docker images if --dev is specified
if [ "$is_dev_mode" == "true" ] && [ -n "$build_docker" ]; then
    if [ -n "$services" ]; then
        build_docker_images
    else
        echo "No services specified for building."
        exit 1
    fi
fi

# Start Docker Compose with optional services
if [ -n "$services" ]; then
    docker compose -f "$compose_file" up $services &
else
    docker compose -f "$compose_file" up &
fi

# Wait for Docker Compose to finish
wait $!
