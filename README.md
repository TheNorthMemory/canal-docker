# [alibaba/canal](https://github.com/alibaba/canal) in docker

[![](https://img.shields.io/docker/cloud/build/thenorthmemory/canal.svg?label=&logo=docker&logoColor=fff)](https://hub.docker.com/r/thenorthmemory/canal)
[![](https://img.shields.io/microbadger/image-size/thenorthmemory/canal.svg?logo=docker&label=&logoColor=fff)](https://hub.docker.com/r/thenorthmemory/canal)
[![](https://img.shields.io/docker/stars/thenorthmemory/canal.svg?logo=docker&logoColor=fff)](https://hub.docker.com/r/thenorthmemory/canal)
[![](https://img.shields.io/docker/pulls/thenorthmemory/canal.svg?logo=docker&logoColor=fff)](https://hub.docker.com/r/thenorthmemory/canal)
[![](https://img.shields.io/github/commit-activity/y/thenorthmemory/canal-docker.svg?label=&logo=github&logoColor=fff)](https://github.com/TheNorthMemory/canal-docker)
[![](https://img.shields.io/github/release/thenorthmemory/canal-docker.svg?label=&logo=github&logoColor=fff)](https://github.com/TheNorthMemory/canal-docker/releases)
[![](https://img.shields.io/github/license/thenorthmemory/canal-docker.svg?label=&logo=github&logoColor=fff)](https://github.com/TheNorthMemory/canal-docker)
[![](https://img.shields.io/github/last-commit/thenorthmemory/canal-docker.svg?label=&logo=github&logoColor=fff)](https://github.com/TheNorthMemory/canal-docker)
[![](https://img.shields.io/github/issues/thenorthmemory/canal-docker.svg?label=&logo=github&logoColor=fff)](https://github.com/TheNorthMemory/canal-docker)

[Dockerfile based on openjdk:8-jdk-alpine](https://github.com/TheNorthMemory/canal-docker/blob/master/Dockerfile)

## Build

command

`docker build --tag thenorthmemory/canal:latest-alpine .`

optional arguments

- `--build-arg GIT_SOURCE_REPO=https://github.com/alibaba/canal.git`
- `--build-arg GIT_SOURCE_BRANCH=canal-1.1.4`

## Usage

version

`docker run --rm thenorthmemory/canal:latest-alpine version`

help

`docker run --rm thenorthmemory/canal:latest-alpine help`

canal-deployer

`docker run --rm -w /alibaba/canal-deployer thenorthmemory/canal:latest-alpine deployer`

canal-adapter

`docker run --rm -w /alibaba/canal-adapter thenorthmemory/canal:latest-alpine adapter`

## License

Apache License Version 2.0
