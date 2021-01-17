# Onedrive Docker Container for arm64/aarch64

![GitHub Workflow Status](https://img.shields.io/github/workflow/status/hvalev/onedrive-docker-arm64/ci)
![Docker Pulls](https://img.shields.io/docker/pulls/hvalev/onedrive-docker-arm64)
![Docker Stars](https://img.shields.io/docker/stars/hvalev/onedrive-docker-arm64)
![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/hvalev/onedrive-docker-arm64)

Onedrive docker client based on https://github.com/abraunegg/onedrive running on arm64/aarch64 using an adapted version of the official amd64 docker image https://hub.docker.com/r/driveone/onedrive. The major change is using the LDC D compiler which supports ARM to the DMD one, used in the official image. And it works so here you go.

## How to run it (please read carefully)
Similar to the normal installation, you need to authorize your onedrive client to sync to your onedrive account. Before you do that though you will need to create the necessary folder structure yourself with the correct permissions and ownership as they need to be assigned to the user account of the machine you will be running this on.
```
mkdir onedrive
mkdir onedrive/conf
mkdir onedrive/data
```
Afterwards you can should run the container with the interactive terminal as there is an additional step required.
```
docker run -it --name onedrive -v ~/onedrive/conf:/onedrive/conf -v ~/onedrive/data:/onedrive/data -e "ONEDRIVE_UID:1000" -e "ONEDRIVE_GID:1000" hvalev/onedrive-docker-arm64
```
You'll see a link in the terminal, which you should copy to your browser of choice. You will need to authenticate yourself, which will connect the app to your onedrive. Afterwards, the page will remain blank, but the url in your browser will change. Copy the generated id from the url back into the docker container. Finally, wait for a few files to begin syncing to ensure that all configuration files have been successfully stored. At this point you can stop or detach the container and run it using  docker-compose or however you want.

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

The docker client supports some additional parameters (such as ONEDRIVE_DOWNLOADONLY, etc), which you can find on the page of the original repository [here](https://github.com/abraunegg/onedrive/blob/master/docs/Docker.md).

## How to build it
You might want to build the container yourself as onedrive might add new functions, update to newer libraries etcetera. This is pretty straighforward as you only need to do the following:
```
docker build https://github.com/hvalev/onedrive-docker-arm64.git --tag onedrive-arm64
```
You'll need 2GB of RAM.

## Dear traveller from the future
If the build does not work, look at the following potential reasons as to why that might be the case:
* The LDC compiler environment is activated statically in the Dockerfile with the version available at the time of writing. The install-script may download a newer version in the future, which needs to be amended. In the build output you can see which version was installed and update the Dockerfile.
* Check the original Dockerfile by onedrive for any breaking changes to paths or variables https://hub.docker.com/r/driveone/onedrive.
* The onedrive git repository (https://github.com/abraunegg/onedrive) is cloned directly into the image. In a future version the entrypoint.sh's location might've changed.
* ~~The date is 30 June 2024 and centos 7 reached its end of life. There might be incompatibilities with the old container, so you'll need to upgrade. The new package manager centos 8 uses is dnf, the successor of yum.~~ [CentOS Is Dead, Long Live CentOS](https://hackaday.com/2020/12/09/centos-is-dead-long-live-centos/).