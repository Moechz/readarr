#!/bin/sh
# TOS wrapper: LinuxServer s6 starts as root (chown + su-exec to abc). Run the
# unmodified Readarr binary directly as uid 1000 with a writable /config.
set -u
set -e
mkdir -p /config
cd /app/readarr/bin
exec ./Readarr -nobrowser -data=/config
