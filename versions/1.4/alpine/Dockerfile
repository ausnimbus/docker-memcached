#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "./hack/run update"
#
# DO NOT EDIT IT DIRECTLY.
#
FROM memcached:1.4-alpine
# <pre>

MAINTAINER AusNimbus <support@ausnimbus.com.au>

LABEL summary="Platform for running Memcached 1.4 applications" \
      maintainer="AusNimbus <support@ausnimbus.com.au>" \
      io.k8s.description="Platform for running Memcached 1.4 applications" \
      io.k8s.display-name="Memcached 1.4"

ENV USER=100 \
    HOME=/opt/app-root/src

USER 0

RUN apk --no-cache add bash rsync && \
    mkdir -p ${HOME}/.pki/nssdb && \
    chown -R 1001:0 ${HOME}/.pki && \
    adduser -S -u 1001 -G root -h ${HOME} -s /sbin/nologin \
      -g "Default Application User" default && \
    chown -R 1001:0 /opt/app-root

# Copy common executable utilities.
COPY ./common/bin/ /usr/bin/

# Each container image can have 'contrib' a directory with extra files needed to
# run and build the application.
COPY ./contrib/ /opt/app-root

# </pre>
# <component>

# Copy the component scripts (override existing container-entrypoint)
COPY ./component/bin/ /usr/bin/

# </component>
# <template>

LABEL io.openshift.expose-services="11211:tcp" \
    io.openshift.tags="component,memcached"

# </template>
# <post>

# Standardize on UID $USER (alpine:3.4 does not have the shadow package)
RUN apk add shadow --no-cache --repository http://rsync.alpinelinux.org/alpine/latest-stable/community/ && \
    usermod -o -u $USER default && \
    apk del shadow

# Drop the root user and make the content of /opt/app-root owned by user default
RUN chown -R $USER:0 /opt/app-root && chmod -R ug+rwx /opt/app-root
USER $USER

ENTRYPOINT ["container-entrypoint"]

# </post>
