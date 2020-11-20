# Onedrive Docker Container for arm64/aarch64
Onedrive docker client based on https://github.com/abraunegg/onedrive running on arm64/aarch64 using an adapted version of the official amd64 docker image https://hub.docker.com/r/driveone/onedrive. The major change is using the LDC D compiler which supports ARM to the DMD one, used in the official image, which at the time of writing does not. And it works so here you go.

# How to run it
Similar to the normal installation, you need to authorize your onedrive client to sync to your account. Before you do that though you'll need to create the necessary folder structure with the correct permission and ownership. If you leave it to docker, it will create the necessary folders as root, while they'll need to be assigned to the user account.
```
mkdir onedrive
mkdir onedrive/conf
mkdir onedrive/data
```
afterwards you can simply run the container
```
docker run -it --name onedrive -v ~/onedrive/conf:/onedrive/conf -v ~/onedrive/data:/onedrive/data -e "ONEDRIVE_UID:1000" -e "ONEDRIVE_GID:1000" hvalev/onedrive-docker-arm64
```
You'll be given a link to enter in your browser, simply enter it, authenticate yourself and the url in the browser will change (page will remain  blank). Copy it back into the container and wait for a few files to sync to ensure that all configuration data has been saved. At this point you can use the docker-compose file in detached mode and onedrive will sync in the background.
```
version: "3.7"
services:
  onedrive:
    image: hvalev/onedrive-docker-arm64
    container_name: onedrive
    environment:
      - ONEDRIVE_UID:1000
      - ONEDRIVE_GID:1000
    volumes:
      - ~/onedrive/data:/onedrive/data
      - ~/onedrive/conf:/onedrive/conf 
    restart: always
```
# How to build it
You might want to build the container yourself as onedrive might add new functions, update to newer libraries etcetera. This is pretty straighforward as you only need to do the following.
```
git clone https://github.com/hvalev/onedrive-docker-arm64.git
docker build onedrive-docker-arm64
```
You'll need 2GB of RAM.

## Dear traveller from the future
If the build does not work, look at the following potential reasons as to why that might be the case:
* Activating the LDC compiler environment is statically referred to in the dockerfile. However, I'm using the install script for it, so the version might've changed. In the build output you can see which version was installed.
* Check the original dockerfile by onedrive for any changes https://hub.docker.com/r/driveone/onedrive.
* The onedrive git repository (https://github.com/abraunegg/onedrive) is cloned directly into the image. In a future version the entrypoint.sh's location might've moved.
* The date is 30 June 2024 and centos 7 reached it's end of life. There might be incompatibilities with the old container, so you'll need to upgrade. The new package manager centos 8 uses is dnf, the successor of yum.
