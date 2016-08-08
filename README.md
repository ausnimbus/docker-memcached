Memcached Docker Image
======================

This repository contains Dockerfile to run Memcached on AusNimbus (OpenShift v3).

Current memcached version is 1.4.30

Configuring
-----------

The following environment variables are available to configure your memcached instance:

* MEMCACHED_MAX_MEMORY: Max memory to use for items in megabytes
* MEMCACHED_MAX_CONNECTIONS: Max simultaneous connections
* MEMCACHED_EXTRA_PARAMETERS: Extra command line parameters to pass to command `memcached`

Running Locally
---------------

To build and run locally, execute:

    git clone https://github.com/ausnimbus/memcached.git
    docker build -t memcached:ausnimbus .
    docker run -d memcached:ausnimbus

Credits
---------------

[GetupCloud](https://getupcloud.com/) who originally created this (<https://github.com/getupcloud/memcached>)
