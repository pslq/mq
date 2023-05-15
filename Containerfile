from icr.io/ibm-messaging/mq:9.3.2.1-r1

COPY export/dmpmqcfg.a.mqsc /etc/mqm/config.mqsc
USER root
RUN groupadd -r -g 1001 mqm && \
    useradd -d /var/mqm -g mqm -G mqm,root -r -u 1001 mqm && \
    install -d -g mqm -o mqm -m 0775 /var/legacy && \
    useradd -m -G mqm,0 -s /bin/true  -p '$6$2LqhxqOL$nhhnQgzewc/h74MXjtJFAdySyTBPJxfM5IprN7Snv5DlueHZoWCMQL00EByKa79gEJjocF3RoWgW4J6d/t1NH/' pqueiroz
COPY export/to_container.tar /var/legacy/to_container.tar
USER mqm
