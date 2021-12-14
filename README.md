# Simple Tarantool Cartridge-based application

This a simplest application based on Tarantool Cartridge.

## Quick start

0. Install centos 7 (CentOS-7-x86_64-Minimal-2009.iso will be enough)
1. Setup network via `nmtui` to make public internet available
2. Copy cannon-0.0.1-0.rpm to /tmp (scp ./cannon-0.0.1-0.rpm root@server:/tmp)
3. Run ./setup.sh script (root privileges needed)

If all steps was successful you will got fully workable cluster:

#|Instance|Role|IPROTO|HTTP
-|-|-|-|-
1 | cannon-stateboard | stateboard | 3301 | 8081
2 | router | router | 3301 | 8081
3 | s1-master | storage | 3302 | 8082
4 | s1-replica | storage | 3303 | 8083
5 | s2-master | storage | 3304 | 8084
6 | s2-replica | storage | 3305 | 8085

## Make some load

1. In `cannon.py` specify Tarantool cluster IP or FQDN
2. Run `python3 cannon.py`

## Useful commands

Att.: All the fo;;owing command must be run into apps dir or in repo dir!

`make .rocks` - install all rocks
`make bootstrap` - bootstrap cluster and fire migrations
`make start` - start cluster
`make stop` - stop cluster
`make migrations` - fire migrations
`make clean` - remove all cluster data, logs and configs
`make clean-rocks` - remove all installed rocks
`make build` - build rpm (`docker` must be installed)
`make all` - runs `make stop && make clean && make bootstrap && make migrations` at once

## Development

For local development (centOS 7) need to install the following packages:

```sh
curl -L https://tarantool.io/installer.sh | sudo -E bash -s -- --repo-only

sudo yum install cartridge-cli tarantool tarantool-devel unzip git cmake centos-release-scl devtoolset-7-gcc* gcc-c++
```
