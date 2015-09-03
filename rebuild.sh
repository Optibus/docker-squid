#!/bin/bash

cd $ROOT/docker-squid && ./dockerbuild.sh
docker rm -fv squidcache
