# tartan_carpet
Main AV software stack setup repository

## Installation

To clone all relevant repos:
1. Clone this repository in a ROS workspace (i.e. ros_ws/src/):
`git clone git@github.com:ipab-rad/tartan_carpet.git`
2. Install vcstool (After ROS is sourced):
`sudo apt update && sudo apt install python3-vcstool`
3. Then, from the tartan_carpet repo, run:

```bash
    # Create src directory
    mkdir src
    # Import AV repos and submodules
    vcs import --recursive --input av.repos ./src
```

### Additional optional steps

#### Import extra repos
These include tools and other repos non-essential for running the stack

```bash
    # Import AV extra repos and submodules
    vcs import --recursive --input extra.repos ./src
```

#### Pull latest code of imported repos
This will pull the latest commits for the target branch of all repos


```bash
    # Pull latest code for all repos recursively
    vcs pull -n
```
### Configure Linux Kernel receive buffer on your host machine

To run any node on your machine, you need to tweak the maximum Linux Kernel receive buffer to allow high throughput messaging:

1. **Create a Configuration File**:
    ```bash
    sudo touch /etc/sysctl.d/10-cyclone-max.conf
    ```

2. **Set the Maximum Receive Buffer**:
    ```bash
    echo "net.core.rmem_max=2147483647" | sudo tee /etc/sysctl.d/10-cyclone-max.conf
    ```

3. **Reload System Configuration**:
    ```bash
    sudo sysctl --system
    ```

Alternatively, you can apply the change for the current session only (the changes will be forgotten after a reboot):

```bash
sudo sysctl -w net.core.rmem_max=2147483647
```

## Running the Sensors

To run all vehicle sensors, including drive-by-wire, simply use the following command:

```bash
./run_sensors.sh
```
Or, if you want to run specific sensors

```bash
./run_sensors.sh <sensor_list>
```
Where `<sensors_list>` is a spaced-separated list containing all the desired sensors to run. See [sensor_compose.yaml](./sensors_compose.yaml) and [radar_compose.yaml](./radar_compose.yaml) for reference.

If the Docker images are not already present on your machine, they will be automatically fetched from the GitHub Docker registry. Please ensure you have access to the registry; for access details, contact @GreatAlexander or @hect95.

To stop the sensors, press `Ctrl + C` in the same terminal.

By default, `run_sensors.sh` will use [sensors_compose.yaml](./sensors_compose.yaml) to run the sensors Docker containers. This file contains versioned Docker image tags that are generated based on the AV project's CI pipeline and cannot be modified.

For development purposes, the script supports the `--dev` flag, which runs Docker containers with the `latest` tag. If you've made local changes to a sensor's Dockerfile(s), you can build and run the local containers using:

```bash
./run_sensors.sh --dev --build av_velodyne av_ouster ...
```

Or, if you only want to build the Docker images without running the containers:

```bash
./run_sensors.sh --build av_velodyne av_ouster ...

# Optionally, build with no cache
./run_sensors.sh --build --no-cache av_velodyne av_ouster ...
```

For reference on which Docker services you can run in development mode, see [dev_sensors_compose.yaml](./dev_sensors_compose.yaml).
