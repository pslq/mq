#/bin/bash
CWD="$(pwd)"
FDD="${CWD}/export"
if [ ! -d "${FDD}" ]; then
  mkdir -p ${FDD}/msg
  (
    cd ${FDD}
    dmpmqcfg -a -o setmqaut > dmpmqcfg.a.setmqaut.sh
    dmpmqcfg -a > dmpmqcfg.a.mqsc
    echo '#!/bin/bash' > restore.ssl.sh
    cnt=0
    for i in $(grep SSLKEYR dmpmqcfg.a.mqsc | cut -d"'" -f2)
    do
      B="$(dirname ${i})"
      tar -czpf ssl_tls_keys.${cnt}.tgz ${B}
      echo "tar -xzpvf ssl_tls_keys.${cnt}.tgz" >> restore.ssl.sh
      let cnt++
    done
    for i in $(grep ' Name=' /var/mqm/mqs.ini | sort -u | cut -d'=' -f2)
    do
      dspmqspl -m ${i} -export > dspmqspl.${i}.export 2> dspmqspl.${i}.cmdout
    done
    echo '#!/bin/bash' > dmpmqmsg.load.sh
    for i in $(awk '{ if ( $0 ~ /DEFINE QLOCAL/ ) print $0; }' < dmpmqcfg.a.mqsc | cut -d"'" -f2)
    do
      (
        (
          dmpmqmsg -i$i -f msg/dmpmqmsg.$i.msg 2>&1 | tee msg/dmpmqmsg.$i.cmdout
          echo  "dmpmqmsg -o${i} -f msg/dmpmqmsg.$i.msg" >> dmpmqmsg.load.sh
        ) &
      )
    done
    wait
    chmod 755 *.sh
    tar -cpvf to_container.tar msg dmpmqmsg.load.sh dspmqspl.*.export *tgz restore.ssl.sh dmpmqcfg.a.setmqaut.sh
    rm -rf msg dmpmqmsg.load.sh dspmqspl.*.export *tgz restore.ssl.sh dmpmqcfg.a.setmqaut.sh
  )
fi
