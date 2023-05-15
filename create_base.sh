#!/bin/bash
ssh -C root@192.168.122.109 \
  '( cd / ; tar -cp --one-file-system --exclude dev --exclude boot --exclude tmp --exclude lib/modules -f - $(mount | awk "{ if ( \$1 ~ /\/dev/ ) print \$3; }" | xargs) )' |\
  podman import --message "old mq 8 env" \
  -c "USER root" -c "VOLUME /var/mqm" \
  - \
  oldmq8:1.0
