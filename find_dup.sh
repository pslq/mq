#!/bin/bash
ssh -C root@192.168.122.109 \
  '( cd / ; tar -cvp --one-file-system  -f /dev/null $(mount | awk "{ if ( \$1 ~ /\/dev/ ) print \$3; }" | xargs) 2>/dev/null )' |\
  sort | uniq -c | grep -v '^ *1 '

