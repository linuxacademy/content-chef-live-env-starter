# Chef Live Env Starter

This repository contains directories for setting up a Chef workstation and auto-bootstraping node within a
live environment.

## Setting up Workstation

1. Install ChefDK
1. Clone/download repository and use `chef-repo`

## Setting up Autobootstraping Node

1. Install Chef
1. Clond/download repository and place `chef` directory at `/etc/chef`
1. (Optional) Set node name by echoing name to `/etc/chef/node_name.txt`
1. Run `sudo chef-client -j /etc/chef/first-boot.json` to register node with empty run-list
