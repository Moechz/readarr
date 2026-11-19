# readarr-for-tos

> TerraMaster TOS 7 App Center — **Docker application** package for
> [Readarr](https://github.com/Readarr/Readarr).

## What this is

A four-file TOS Docker application archive (`readarrdocker.tar.gz`) that installs
Readarr on TOS 7 through the App Center:

- `config.ini` — TOS application metadata (`application_type: docker`, id `readarrdocker`)
- `readarrdocker.lang` — 23-language superset (TOS requires 14)
- `readarrdocker.svg` — application icon (274 bytes, 2 SVG elements)
- `docker-compose.yml` — one service, image `linuxserver/readarr:0.3.10-develop`

## How it works

| | |
|---|---|
| Container image | `linuxserver/readarr:0.3.10-develop` (Docker Hub, used unmodified) |
| Open | `http://<NAS-IP>:8091/` (container port 8787) |
| Runs as | non-root, `user: "1000:1000"` |
| Persistent data | `/config` → `.../readarrdocker/config`, `/books` → `.../readarrdocker/books`, `/downloads` → `.../readarrdocker/downloads` |
| Logs | `docker logs readarrdocker` (stdout/stderr) |



## Privacy

This application runs entirely on your NAS. **The developer does not collect, receive or
have access to any data processed by the application.** There is no telemetry, no analytics
and no account.

| Topic | Detail |
|---|---|
| Data processed | `/config` (settings incl. the API key, the database, logs and backups), `/books` (your library) and `/downloads` (the completed-download folder Readarr imports from). |
| Where it is stored | The application data folder (`/Volume1/DockerAppData/readarrdocker/`) on your NAS. Nothing is uploaded to the developer. |
| Retention period | Until **you** delete it. Readarr rotates its own logs and database backups; uninstalling keeps the data unless you tick “delete data”. |
| Your rights | **Access / export**: copy the data folder. **Correct**: change the values in the web UI. **Delete**: uninstall with “delete data”, or remove the folder after stopping the container. |
| Deletion channel | Delete the folder yourself, or email **moechz@163.com** (answered within 30 days). |
| Security measures | uid 1000 (never root), no `privileged`, no host network, no `cap_add`, no Docker socket, one published port, config files `0600` (`umask 077`). **The WebUI has no password by default — enable authentication before exposing it.** |
| Children | Not directed at children. |

**Full privacy policy:** [PRIVACY.md](PRIVACY.md) —
<https://github.com/Moechz/readarr/blob/main/PRIVACY.md> — and the website version at
<https://www.moechz.com/privacy.html>.

## Third-party services (API disclosure)

The developer operates no server in this path. The application contacts only the services
**you configure**, plus (optionally) an update check and the image registry.

| Service | Endpoint | Data sent | Destination / region |
|---|---|---|---|
| Book metadata (automatic when you search/add a book) | `https://api.bookinfo.club/v1/…` | the author/book name you search, your IP | bookinfo.club (community service, EU/US) |
| Update check (on by default) | `https://readarr.servarr.com/v1/update/{branch}` | app version, OS, whether the install was active last month | the Servarr project, US |
| Indexers you add | the URL you enter | search query, your IP, that indexer's API key | the indexer you chose |
| Download clients you add | the host you enter | release URL, category, credentials | your LAN or the client you chose |
| Notification providers you add | the provider's endpoint | the notification text | that provider |
| OPDS / Kavita (if configured) | the URL you enter | library requests | that server |
| Image pull | `registry-1.docker.io` or your mirror | anonymous pull | Docker Hub, US / your mirror |

See `PRIVACY.md` §6 for the full table. Disable any integration in the app's settings if you
do not want it.

## Upstream status

Readarr was archived upstream on **2025-06-27**, and LinuxServer.io archived the image
repository the same day. The last published image build is `linuxserver/readarr:0.3.10-develop`
(digest `sha256:c39c1fe2…`, built 2023-12-07 on Alpine 3.18). Because the store allows only
unmodified images from a trusted registry, this package cannot patch the application or its
base image by itself; it pins the last build and runs it with the smallest possible surface
(uid 1000, one port, no capabilities, no host network, no Docker socket). A vulnerability
finding against the image can only be fixed by a new upstream build — if one appears, a new
package iteration will follow.

## Licence and attributions

| Component | Licence | Notes |
|---|---|---|
| Readarr | GPL-3.0 | upstream application, used unmodified inside the image |
| Container image `linuxserver/readarr:0.3.10-develop` | see the image's own metadata | pulled from Docker Hub at install time |
| This packaging | GPL-3.0 (see `LICENSE`) | compose file, metadata, translations, icon |

“Readarr”, “TerraMaster” and “TOS” are trademarks of their respective owners. This is an
independent community package by Moechz and is not affiliated with the upstream project or
TerraMaster. Full details: [NOTICE.md](NOTICE.md).

## Design highlights

- **Non-root.** `user: "1000:1000"`; verified on real hardware (the container reports uid 1000).
- **Entrypoint wrapper**: the upstream image is built to run as root and keeps state in root-owned paths, so the compose file replaces the entrypoint with `src/entrypoint.sh`, which makes the service run as an unprivileged user. See that file for the details.
- **Fixed image tag, never `:latest`**, Docker Hub only, no `privileged`, no `network_mode: host`, and no Docker socket, no `cap_add`.
- **Health check** on `/ping` with `curl -f`, so a broken service is reported as unhealthy.
- **Archived upstream.** Readarr and LinuxServer.io's image repo were archived on 2025-06-27;
  the image is the last published build. See `## Upstream status` below.
- **Deterministic build**: GNU tar with uid/gid 0 and zeroed timestamps, gzip without a timestamp, plus the review-standards self-check above.

## Runtime file manifest

Everything the application writes on the NAS lives inside its own data
directory; the container-internal `/tmp` is discarded with the container. The
table lists what is created and how it behaves. Nothing else is written.

| Path | Purpose | Created when | Growth bound | Lifecycle |
|---|---|---|---|---|
| `/Volume1/DockerAppData/readarrdocker/config` | `config.xml` (API key, auth), `readarr.db`, logs, `Backups/` | on first start / on demand | bounded by your library | persistent; kept on uninstall unless you ask to delete it |
| `/Volume1/DockerAppData/readarrdocker/books` | your library (root folder `/books`) | when you import books | bounded by your library | persistent |
| `/Volume1/DockerAppData/readarrdocker/downloads` | completed downloads your client writes, Readarr imports from here | when your client downloads | bounded by your activity | persistent |

## Build

```bash
scripts/build.sh                  # -> out/readarrdocker.tar.gz + .sha256
scripts/build.sh 0.3.10-4            # packaging iteration bump
scripts/build.sh 0.3.10-4 aarch64    # explicit platform (both are published)
```

The build stages the four files, substitutes the version/platform placeholders,
embeds `src/entrypoint.sh` into the compose file (escaping every `$` as `$$`), removes CRLF/BOM/AppleDouble, then runs
`tools/verify.py`, a review-standards self-check (archive layout, JSON validity,
required fields, 14+ language coverage, version consistency, Docker-Hub-only
images, fixed tag, reserved/recommended host ports, non-root user, per-service
healthcheck/TZ/restart, data path below the application data root, never the
`/Volume*` wildcard, comment-free sequence blocks, `x-app-meta` position, no
literal secrets and the SVG size/element limits).

## Local verification

```bash
./TOSAppSelfTestingTool -c out/readarrdocker.tar.gz   # official spec check
bash test/install-and-verify.sh                  # on-device E2E (needs root)
```

> Docker applications cannot be side-loaded through the App Center's manual
> install page (it accepts `.deb` only); the official self-testing tool's `-i`
> mode or `docker compose` are the only ways to install one for testing.

## Store submission checklist

1. Public GitHub repo (code + README only).
2. Release **tag `v0.3.10-4`**, assets `readarrdocker_x86_64.tar.gz` +
   `readarrdocker_aarch64.tar.gz` (+ `.sha256` each) — Docker asset naming:
   `<app_id>_<arch>.tar.gz`, one archive per architecture.
3. Developer platform → Add Application: ID `readarrdocker`, package type Docker,
   repository URL, architecture `x86_64` (and a second record for `aarch64`).
4. Version Management → Add Version `0.3.10-4` → automated validation → review.


## Limitations

- The application runs inside a container; data lives in the application data directory (`/Volume1/DockerAppData/readarrdocker/`) as described above.

---

Packaged for TOS 7 by Moechz. Upstream image used unmodified from Docker Hub.

## Support

- Issues and questions: <https://github.com/Moechz/readarr/issues>
- Email: moechz@163.com
- Privacy: [PRIVACY.md](PRIVACY.md) · Licence: [NOTICE.md](NOTICE.md)
