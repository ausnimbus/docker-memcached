FROM  openshift/base-centos7

MAINTAINER AusNimbus <support@ausnimbus.com.au>

ENV MEMCACHED_VERSION 1.4.35
ENV MEMCACHED_SHA1 787991c0df75defbb91518c9796f8244852a018a

LABEL io.k8s.description="Memcached is a general-purpose distributed memory caching system." \
      io.k8s.display-name="Memcached 1.4" \
      io.openshift.expose-services="11211:memcache" \
      io.openshift.tags="cache,memcached"

EXPOSE 11211

RUN yum install --enablerepo=centosplus -y centos-release-scl epel-release && \
    yum install -y --setopt=tsflags=nodocs --enablerepo=centosplus libevent-devel libevent && \
    rpm -V libevent-devel libevent && \
    yum clean all -y

RUN curl -SL "http://memcached.org/files/memcached-$MEMCACHED_VERSION.tar.gz" -o memcached.tar.gz && \
    echo "$MEMCACHED_SHA1 memcached.tar.gz" | sha1sum -c - && \
    mkdir -p /usr/src/memcached && \
    tar -xzf memcached.tar.gz -C /usr/src/memcached --strip-components=1 && \
    rm memcached.tar.gz && \
    cd /usr/src/memcached && \
    ./configure && \
    make && \
    make install && \
    cd / && rm -rf /usr/src/memcached

COPY container-entrypoint /usr/bin/

USER 1001
ENTRYPOINT ["container-entrypoint"]
CMD ["memcached"]
