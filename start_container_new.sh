#!/bin/bash
podman run \
    --env LICENSE=accept --env MQ_ADMIN_PASSWORD=12qwaszx \
    --env MQ_APP_PASSWORD=12qwaszx --env MQ_QMGR_NAME=PQUEIROZ \
    -p 1414:1414 -p 9157:9157 -p 9443:9443 -it \
   new_mq:1.0
