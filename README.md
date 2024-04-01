# tartan_carpet
Main AV software stack setup repository

## Instructions

To clone all relevant repos:
1. Clone this repository in a ROS workspace (i.e. ros_ws/src/): 
`git clone git@github.com:ipab-rad/tartan_carpet.git`
2. Install vcstool (After ROS is sourced): 
`sudo apt update && sudo apt install python3-vcstool`
3. Then, from the tartan_carpet repo, run: 
`vcs import --input av.repos ../`
