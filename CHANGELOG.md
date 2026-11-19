# Changelog

All notable user-visible changes to the Readarr TOS application package.

## 0.3.10-4 — 2026-11-19

Follow-up to the 2026-11-15 review of `0.3.10-2` (12 items, none of which blocked the
listing; they had to be fixed in the next version).

### Added
- **Persistent `/books` and `/downloads` volumes.** Readarr needs a library root folder and a
  completed-downloads folder to import from; without them the advertised “grab, import, rename”
  workflow could not be used at all (the F5 finding).
- `PRIVACY.md` rewritten for this app: what `/config`, `/books` and `/downloads` contain, the
  retention of the readarr database backups, the user-rights/deletion channel, and the real
  third-party endpoints (see below). The `help` field of `config.ini` — the App Center “Help”
  link — now points at it.
- Full third-party disclosure (C8): `https://api.bookinfo.club/v1/…` (book metadata, the search
  term you type), `https://readarr.servarr.com/v1/update/{branch}` (update check: version, OS,
  install-active flag), the indexers, download clients and notification providers the user
  configures, an OPDS/Kavita server if one is configured, and the Docker Hub image pull.
- `docs/CVE-REMEDIATION.md` (repository: the `## Upstream status` section of the README): the
  T1 position — Readarr and LinuxServer.io's image repo were archived on 2025-06-27, the image
  is the last published build.

### Fixed
- Chinese (`zh-cn`, `zh-hk`) descriptions and `important` text described a completely
  different application (left over from the packaging template); rewritten for Readarr,
  including the “enable authentication” warning (the WebUI has no password by default).
- `config.ini` `help` pointed at the issue tracker; the package metadata, README and website
  now carry the privacy policy instead.
- Configuration files are created with `umask 077` so `config.xml` (which holds the API key)
  is not world-readable (the S11 finding).
- Health check documented as `curl -f` on `/ping`; no behaviour change.

## 0.3.10-3 — 2026-11-17

### Added
- `PRIVACY.md`, `NOTICE.md` and the README compliance sections (privacy, third-party
  services, licence, runtime manifest) — first response to the 2026-11-15 review.

## 0.3.10-2 — 2026-11-12

### Changed
- Replaced the letter-monogram icon with the Readarr application mark (icon specification).

## 0.3.10-1 — 2026-11-11

### Added
- First release. Readarr (`linuxserver/readarr:0.3.10-develop`, Docker Hub official image, unmodified)
  packaged as a TOS 7 Docker application, published on port 8091 and running
  as a non-root user (1000:1000).
- Persistent data is kept under `/Volume1/DockerAppData/readarrdocker/`.
