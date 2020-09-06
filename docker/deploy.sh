#!/usr/bin/env sh

set -ex

cd ~/apps/bugzilla_ex
git pull
docker build . -t bugzilla/app:latest
(cd docker && docker-compose up -d)
