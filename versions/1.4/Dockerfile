#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "./hack/run update"
#
# DO NOT EDIT IT DIRECTLY.
#
FROM memcached:1.4
# <pre>

MAINTAINER AusNimbus <support@ausnimbus.com.au>

LABEL summary="Platform for running Memcached 1.4 applications" \
      maintainer="AusNimbus <support@ausnimbus.com.au>" \
      io.k8s.description="Platform for running Memcached 1.4 applications" \
      io.k8s.display-name="Memcached 1.4"

ENV USER=999 \
    HOME=/opt/app-root/src

USER 0

RUN apt-get update && apt-get install -y \
      rsync nano vim && \
    ln -sf /bin/bash /bin/sh && \
    mkdir -p $HOME && \
    useradd -u 1001 -g 0 -d $HOME -s /sbin/nologin \
      -c "Default Application User" default && \
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

# Standardize on UID $USER
RUN usermod -o -u $USER default

# Drop the root user and make the content of /opt/app-root owned by user default
RUN chown -R $USER:0 /opt/app-root && chmod -R ug+rwx /opt/app-root
USER $USER

ENTRYPOINT ["container-entrypoint"]

# </post>
