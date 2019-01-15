# [alibaba/canal](https://github.com/alibaba/canal) in docker

[![](https://img.shields.io/docker/automated/thenorthmemory/canal.svg)](https://hub.docker.com/r/thenorthmemory/canal)
[![](https://img.shields.io/docker/pulls/thenorthmemory/canal.svg)](https://hub.docker.com/r/thenorthmemory/canal)
[![](https://img.shields.io/github/last-commit/thenorthmemory/canal-docker.svg)](https://github.com/TheNorthMemory/canal-docker)
[![](https://img.shields.io/github/repo-size/thenorthmemory/canal-docker.svg)](https://github.com/TheNorthMemory/canal-docker)

[Dockerfile based on openjdk:8-jdk-alpine](https://github.com/TheNorthMemory/canal-docker/blob/master/Dockerfile)

## Build

`docker build --build-arg CANAL_VERSION=1.1.2 --tag thenorthmemory/canal:1.1.2-alpine .`

## Usage

version

`docker run --rm thenorthmemory/canal:1.1.2-alpine version`

help

`docker run --rm thenorthmemory/canal:1.1.2-alpine help`

canal-deployer

`docker run --rm -w /alibaba/canal-deployer thenorthmemory/canal:1.1.2-alpine deployer`

canal-adapter

`docker run --rm -w /alibaba/canal-adapter thenorthmemory/canal:1.1.2-alpine adapter`

## License

Apache License Version 2.0