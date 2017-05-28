# AusNimbus Memcached

[![Build Status](https://travis-ci.org/ausnimbus/memcached-component.svg?branch=master)](https://travis-ci.org/ausnimbus/memcached-component)
[![Docker Repository on Quay](https://quay.io/repository/ausnimbus/memcached-component/status "Docker Repository on Quay")](https://quay.io/repository/ausnimbus/memcached-component)

This repository contains the source for deploying [memcached](https://www.ausnimbus.com.au/instant-apps/memcached/)
on [AusNimbus](https://www.ausnimbus.com.au/).

## Environment Variables

The following environment variables are available to configure your memcached instance:

- MEMCACHED_MAXMEMORY: Max memory memcached can use (default: automatically configured)
- MEMCACHED_EXTRA_OPTIONS: Extra parameters to passed to `memcached`

## Versions

The versions currently supported are:

- 1.4
