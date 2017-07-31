# AusNimbus Component for Memcached [![Build Status](https://travis-ci.org/ausnimbus/memcached-component.svg?branch=master)](https://travis-ci.org/ausnimbus/memcached-component) [![Docker Repository on Quay](https://quay.io/repository/ausnimbus/memcached-component/status "Docker Repository on Quay")](https://quay.io/repository/ausnimbus/memcached-component)

[![Memcached](https://user-images.githubusercontent.com/2239920/27766377-205545f0-5f11-11e7-8cc9-a0b23720c7ed.jpg)](https://www.ausnimbus.com.au/)

The [AusNimbus](https://www.ausnimbus.com.au/) component for [Memcached](https://www.ausnimbus.com.au/instant-apps/memcached/).


This document describes the behaviour and environment configuration when running Redis on AusNimbus.

## Table of Contents

- [Runtime Environments](#runtime-environments)
- [Environment Configuration](#environment-configuration)

## Runtime Environments

AusNimbus supports the latest stable release for Redis.

The currently supported versions are `1.5`

## Environment Configuration

The following environment variables are available for you to configure your Redis environment:

NAME                       | Description
---------------------------|-------------
MEMCACHED_MAXMEMORY        | Max memory memcached can use (default: automatically configured)
MEMCACHED_EXTRA_OPTIONS    | Extra parameters to passed to `memcached`
