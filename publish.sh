#!/bin/bash
version=0.5.1
repo=ghcr.io/louisemoe/phoenixd

docker buildx build . --build-arg PHOENIXD_VERSION=$version -t $repo:$version -t $repo:latest
docker push -a $repo
