#!/bin/bash

if [ ! "$@" ];then
  /usr/sbin/sshd -D
else
  /usr/sbin/sshd -D &
  exec "$@"
fi
