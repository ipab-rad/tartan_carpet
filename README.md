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

## Run sensors

To run all vehicle sensors, including drive-by-wire, use the following command

```bash
    docker compose -f ./sensors_compose.yaml up
```

If the docker images are not already downloaded, they will be automatically fetched from the GitHub Docker registry. Ensure you have access to the GitHub Docker registry; please contact @GreatAlexander or @hect95 for access details.

To stop the sensors, press `Ctrl + C` in the same terminal. Additionally, you can remove the created Docker containers with:

```bash
    docker compose -f ./sensors_compose.yaml down
```
