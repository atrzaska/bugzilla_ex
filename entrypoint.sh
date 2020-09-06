#!/bin/env sh

set -e

case "$1" in
  start)
    bin/bugzilla eval "Bugzilla.Release.migrate"
    bin/bugzilla start
    ;;

  migrate)
    bin/bugzilla eval "Bugzilla.Release.migrate"
    ;;

  rollback)
    bin/bugzilla eval "Bugzilla.Release.rollback"
    ;;

  shell)
    /bin/sh
    ;;

  *)
    bin/bugzilla start
    ;;
esac
