# [alibaba/canal](https://github.com/alibaba/canal) in docker

## Build

`docker build --build-arg CANAL_VERSION=1.1.2 --tag thenorthmemory/canal:1.1.2-alpine .`

## Usage

canal-deployer

`docker run --rm -w /alibaba/canal-deployer thenorthmemory/canal:1.1.2-alpine java com.alibaba.otter.canal.deployer.CanalLauncher`

canal-adapter

`docker run --rm -w /alibaba/canal-adapter thenorthmemory/canal:1.1.2-alpine java com.alibaba.otter.canal.adapter.launcher.CanalAdapterApplication`

## License

Apache License Version 2.0