#!/bin/sh
# TOS wrapper: LinuxServer s6 starts as root (chown + su-exec to abc). Run the
# unmodified Readarr binary directly as uid 1000 with a writable /config.
set -u
set -e
umask 077          # config.xml holds the API key; keep it owner-only
mkdir -p /config /books /downloads
cd /app/readarr/bin
exec ./Readarr -nobrowser -data=/config
