# olomana
The PWS 2.0 redesign, successor to https://github.com/runyanjake/whitney.

## About

### Background
Whitney was the codename for my first homelab setup (For reference: https://www.reddit.com/r/homelab/). It was built out of my friend's handmedown hardware in an old server case that was e-wasted from school. This initial build was on the "janky" side, featuring an unmounted power supply in the optical bay, secured only by some green yarn. (Fire hazard, anyone?)  
[Picture Here]  
I ran a lot of services from this box - my personal website/online resume, side projects, a Covid-19 data tracker, game servers, and a lot of other projects that taught me lessons in DNS config, networking, maintaining persistent storage and others.  
But eventually I started running up against the limits of the box. The machine's CPU was released in 2008, which was indicative of the age of most of its hardware. After spending a lot of work on the original Whitney config in the first repo, I decided that I had learned enough to warrant an upgrade.

### The Upgrade
PWS 2.0 was given the nickname of "Olomana", a second step in this pattern of mountainous server names. Mount Olomana (https://en.wikipedia.org/wiki/Olomana\_(mountain)) is a mountain on the Windward side of Oahu, Hawaii. It has 3 peaks which are are a popular, albeit difficult and dangerous hike. While visiting family in Kailua, I hiked the Ko'olau range and snapped this picture of the rarely seen backside of Mount Olomana.  
Olomana, the web server will be a significant upgrade over its predecessor. I am building it as a 4U rack-mounted machine with new components. The 16U rack it is mounted in was sourced from the popular website www.racksolutions.com. The build itself includes a number of current gen budget components. Cricital resources like Ram and CPU cores are more abundant in the new build. I got a UPS and a dedicated write drive that were tested on PWS 1.0 to combat some data corruption issues I had faced on the old hardware.  
[Picture here]

## Setup

### Hardware

#### Hard Drives/Filesystem
- Manage disk partitions with `gdisk`, configure mounts by editing `/etc/fstab`. See https://techguides.yt/guides/how-to-partition-format-and-auto-mount-disk-on-ubuntu-20-04/  
- Configure ZFS pool using at least `raidz1` for data that should not be lost. Other data can go in drives directly mounted at the root.

#### Nvidia GPU Setup
1. Install Nvidia Drivers, see https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#ubuntu  
2. Resolved issue with old key by following method 2 in this issue: https://github.com/NVIDIA/cuda-repo-management/issues/4  
3. Install `nvidia-docker`, see https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker

### Software

#### OpenSSH
```
sudo apt-get install openssh-server
```
Port forward port 22 on the gateway.
```
sudo ufw enable
sudo ufw allow 22
sudo ufw reload
```

#### Neovim/LazyVim
The OS may not be bundled with GCC which is required for neovim variants. It is part of `build-essential`, a bundle of useful build tools.
```
sudo apt install build-essential
```

Better vim editor.
```
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update
sudo apt-get install neovim
```
This installs a new-ish version of neovim. To install and configure LazyVim, follow customization steps in my [dotfiles repo](https://github.com/runyanjake/dotfiles/tree/main/neovim).

#### Neofetch
System stats, visualized.
```
sudo apt-get install neofetch
```

#### Github CLI
Install gh CLI tool.
```
sudo apt-get install gh
```
Generate new SSH key to upload to Github if you'll be pushing or downloading private repos.
```
ssh-keygen -t rsa -C "your-email@example.com"
```
Edit `~/.ssh/config` so the key is used.
```
Host github.com
    User git
    IdentityFile ~/.ssh/id_rsa
```
Make sure the key is added to github before doing anything else.  
You will likely need to make a Personal Access Token upload key. It must have the following permissions.
```
workflow
admin::public_key
read::org
```
Authenticate with the CLI:
```
gh auth login
```
Clone this repo
```
gh repo clone runyanjake/olomana
```

#### Docker
See https://linuxiac.com/how-to-install-docker-on-ubuntu-24-04-lts/
```
sudo apt install apt-transport-https curl
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl is-active docker
```

#### Misc

##### Set System Time
```
timedatectl list-timezones
sudo timedatectl set-timezone America/Los_Angeles
```
