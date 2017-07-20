#!/usr/bin/env bash

set -e

readonly modules=$(ls /lib/modules/$(uname -r)/kernel/net/netfilter/xt_* | grep -oP '(?<=xt_)([a-z]+)')

for m in $modules
do
  helps=$(iptables -m "$m" -h 2>&1 | awk '/match options:$/,0' | sed 's/^/   /')

  if [[ -z $helps ]]
  then
    continue
  fi

  echo "--------------------------------------------------------------------"
  echo
  echo "$helps"
  echo
done