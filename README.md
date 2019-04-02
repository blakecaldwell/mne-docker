# mne-docker

This repository simply contains components for running mne-python inside docker containers on Mac/Windows/Linux with X11

The commands below assume that docker-compose is already installed.

## Running for the first time

```
cd mne-docker
docker-compose up -d
```

A directory `shared` will be created in the directory where `docker-compose` was ran. This directory is accessible within the container at /home/mne_user/shared

## Restarting mne-docker container

```
docker-compose restart
```


