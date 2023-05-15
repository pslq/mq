
#!/bin/bash

podman run -it \
  -p 1414:1414 \
  -p 9157:9157 \
  -p 9443:9443 \
  -p 22:22 \
  --hostname centos6 \
  localhost/oldmq8:1.0 /bin/bash
