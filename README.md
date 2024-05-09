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

## Run sensors

To run all vehicle sensors, including drive-by-wire, use the following command

```bash
    docker compose -f ./sensors_compose.yaml up
```

If the docker images are not already downloaded, they will be automatically
fetched from the GitHub Docker registry. Ensure you have access to the GitHub
Docker registry; please contact @GreatAlexander or @hect95 for access details.

To stop the sensors, press `Ctrl + C` in the same terminal. Additionally, you
can remove the created Docker containers with:

```bash
    docker compose -f ./sensors_compose.yaml down
```
