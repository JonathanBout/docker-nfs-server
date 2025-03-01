ARG BUILD_FROM=alpine:latest

FROM $BUILD_FROM

# provide a default directory to mount to
# http://wiki.linux-nfs.org/wiki/index.php/Nfsv4_configuration

RUN mkdir /data                                                                          && \
    mkdir -p /var/lib/nfs/rpc_pipefs                                                     && \
    mkdir -p /var/lib/nfs/v4recovery                                                     && \
    echo "rpc_pipefs  /var/lib/nfs/rpc_pipefs  rpc_pipefs  defaults  0  0" >> /etc/fstab && \
    echo "nfsd        /proc/fs/nfsd            nfsd        defaults  0  0" >> /etc/fstab

RUN apk --update --no-cache add bash nfs-utils libcap && \
                                                  \
    # remove the default config files
    rm -v /etc/idmapd.conf /etc/exports

EXPOSE 2049

# setup entrypoint
COPY ./entrypoint.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
