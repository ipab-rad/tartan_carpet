#!/bin/bash

help() {
    echo "Usage: run_sensors.sh [options] [sensor_list]

    Options:
      --dev        Use the 'dev_sensors_compose.yaml' file
      --build      Build Docker images for the specified sensors (only valid with --dev)
      --build-only Only build Docker images
      --local        Use the 'local_sensors_compose.yaml' file
      --no-cache   Build Docker images with no cache
      --ros-time   Use internal ROS timestamps for lidar msgs (i.e. not GPS/PPS)
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
<<<<<<< HEAD
is_dev_mode="false"
run_services="true"
build_no_cache=""
ros_time="false"

while [[ $# -gt 0 ]]; do
    case $1 in
        --dev)
            compose_file="./dev_sensors_compose.yaml"
            is_dev_mode="true"
            shift
            ;;
        --build)
            build_docker="true"
            shift
            ;;
        --build-only)
            build_docker="true"
            run_services="false"
=======
run_action_count=0  # Counter to track --local and --build
build_no_cache=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --local)
            compose_file="./local_sensors_compose.yaml"
            ((run_action_count++))  # Increment counter for --local
            shift
            ;;
        --build)
            build_docker="True"
            ((run_action_count++))  # Increment counter for --build
>>>>>>> 2c8fd757f750d5d88238d35a50005f65432f531c
            shift
            ;;
        --no-cache)
            build_no_cache="--no-cache"
            shift
            ;;
        --ros-time)
            ros_time="true"
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
                docker build $build_no_cache -t "$service:latest" --target runtime .
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

<<<<<<< HEAD
# Only build Docker images if --dev is specified
if [ "$is_dev_mode" == "true" ] && [ -n "$build_docker" ]; then
=======
# If both --local and --build are provided, first build, then run Docker Compose
if [ "$run_action_count" -eq 2 ]; then
    if [ -n "$services" ]; then
        build_docker_images
        docker compose -f "$compose_file" up $services &
    else
        echo "No services specified for building."
        exit 1
    fi

    # If only --build is provided, build the Docker images but don't run services
elif [ -n "$build_docker" ]; then
>>>>>>> 2c8fd757f750d5d88238d35a50005f65432f531c
    if [ -n "$services" ]; then
        build_docker_images
    else
        echo "No services specified for building."
        exit 1
    fi
<<<<<<< HEAD
fi

if [ "$run_services" == "true" ]; then
    # Edit compose_file name if needed for ros_time version
    if [ "$ros_time" == "true" ]; then
        compose_file=${compose_file::-5}"_ros_time.yaml"
    fi
    # Start Docker Compose with optional services
=======

    # Default case: run Docker Compose with the defined compose file
else
>>>>>>> 2c8fd757f750d5d88238d35a50005f65432f531c
    if [ -n "$services" ]; then
        docker compose -f "$compose_file" up $services &
    else
        docker compose -f "$compose_file" up &
    fi
fi

# Wait for Docker Compose to finish
wait $!
