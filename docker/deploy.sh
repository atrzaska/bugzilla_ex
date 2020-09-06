#!/usr/bin/env sh

set -ex

(
  CWD=$(cd $(dirname "$0");pwd)
  PROJECT_PATH=$CWD/..
  cd $PROJECT_PATH

  git pull
  docker build . -t bugzilla/app
  (cd docker && docker-compose up -d)
)
