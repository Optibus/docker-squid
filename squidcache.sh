#!/bin/bash
if [[ "$JENKINS_HOME" != "" ]] || [[ "$NO_SQUID" != "" ]] || [[ "$SQUID_UP" != "" ]]; then
    exit 0
fi

if ! docker history d.optibus/squidcache > /dev/null 2>&1 ; then
    cd $ROOT/docker-squid
    ./dockerbuild.sh
fi

if ! docker ps | grep squidcache > /dev/null 2>&1 ; then
    if docker inspect squidcache > /dev/null 2>&1 ; then
        docker rm squidcache > /dev/null
    fi
    docker run -d --net host -v /root/aptcacherng:/var/cache/apt-cacher-ng -v /root/squidcache:/var/spool/squid3 --name squidcache d.optibus/squidcache >/dev/null
fi

OS=$(uname)

if [[ "$OS" == "Darwin" ]]; then
    if docker-machine >/dev/null 2>&1 ; then
        PROXY_IP=$(docker-machine ip dev)
    else
        PROXY_IP=$(boot2docker ip)
    fi
else
    PROXY_IP=localhost
fi
echo "$PROXY_IP"
