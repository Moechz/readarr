# Privacy Policy — Readarr for TerraMaster TOS (`readarrdocker`)

**Last updated:** 19 November 2026
**Data controller / contact:** Moechz — moechz@163.com

This policy covers the TOS application `readarrdocker` (the “app”) and its packaging.
The App Center “Help” link of the application points at this policy
(<https://github.com/Moechz/readarr/blob/main/PRIVACY.md>), and the same text is published on
the website version linked at the end.

## 1. Summary

- The app runs **entirely on your NAS**. The developer does not receive, collect or have
  access to your data: no account, no telemetry service operated by the developer, no crash
  reporting.
- Readarr itself talks to a small number of third parties: a **book metadata service**, an
  **update check**, and the **indexers, download clients and notification providers you
  configure**. Nothing else leaves the NAS (details in §6).
- The app has no built-in login by default (Readarr ships with authentication “None” for
  local access). Enable authentication in *Settings → General* before exposing it, as the
  store description also says.

## 2. What data is processed

| Container path | Stored on the NAS at | Contents |
|---|---|---|
| `/config` | `/Volume1/DockerAppData/readarrdocker/config` | `config.xml` (port, API key, authentication settings), `readarr.db` (authors, books, indexers, download clients, history), the application log and its backups |
| `/books` | `/Volume1/DockerAppData/readarrdocker/books` | your library: the book files Readarr imports and renames into the root folder |
| `/downloads` | `/Volume1/DockerAppData/readarrdocker/downloads` | the completed-download folder of your download client, which Readarr reads to import a release |

Nothing is uploaded to the developer. The Readarr API key lives in `config.xml` (mode `0600`,
created with `umask 077`).

## 3. Retention period

- **Application data, library and downloads:** kept until **you** delete them. There is no
  automatic expiry and no upload. Uninstalling the app keeps the data unless you tick “delete
  data”.
- **Logs:** the application's own log files are rotated/size-limited by Readarr (Settings →
  General → Logging); container stdout/stderr follows the DockerEngine log rotation.
- **Backups:** Readarr keeps automatic database backups under `/config/Backups`; the retention
  is the number of backups you configure in the app.
- **Website/server logs (moechz.com):** short-lived operational logs, not used for profiling.

## 4. Your rights and the deletion channel

| Right | How |
|---|---|
| Access / export | Copy `/Volume1/DockerAppData/readarrdocker/` — it is the complete state; the library itself is `/books`. |
| Correct | Change the values in the app's own web UI (or edit `config.xml` while the app is stopped). |
| Delete | Uninstall the app with “delete data”, or stop the container and remove `/Volume1/DockerAppData/readarrdocker/`. |
| Restrict | Stop the container, or remove the indexer/download client/notification entries in the app. |
| Assistance | Email **moechz@163.com** with the subject “Readarr data request”; a reply follows within 30 days. |

The developer holds no copy of your data, so deletion is normally completed by removing the
folder on your own NAS; the email channel exists for questions and for requests about the
website or the publishing records.

## 5. Security measures

- The container runs as **uid 1000**, never root; no `privileged`, no `cap_add`, no host
  network, no Docker socket.
- Only the application's own port is published.
- Configuration files (including the API key) are created with `umask 077` and stay owned by
  the application user.
- Data stays inside the application data folder, owned by the app user.
- **Enable authentication** in *Settings → General* (and use a TLS reverse proxy if the UI is
  reachable from outside your LAN).
- The image tag is pinned to the last build published by LinuxServer.io. **The Readarr project
  has been archived upstream** (June 2025) and no further releases or image updates are
  produced, so the application does not receive upstream security fixes; see §7.

## 6. Third-party sharing and API disclosure

The developer shares nothing. The app contacts the endpoints below.

| Service | Endpoint | Data sent | Destination / region |
|---|---|---|---|
| Book metadata (automatic when you add or search a book/author) | `https://api.bookinfo.club/v1/…` | the author or book name you search for, your IP address | bookinfo.club (community metadata service, EU/US) |
| Update check (default on in Readarr) | `https://readarr.servarr.com/v1/update/{branch}` | current app version, operating system, and whether the install was active in the last month | the Servarr project, US |
| Indexers you add (Newznab/Torznab, etc.) | the URL you enter | search query, your IP address, the API key of that indexer | the indexer you chose |
| Download client you add (qBittorrent, SABnzbd, …) | the host you enter | release URL, category, credentials | normally your LAN or the client you chose |
| Notification providers you add (Slack, Gotify, ntfy, Pushover, Telegram, …) | the endpoint of the provider | the notification text | that provider |
| OPDS / Kavita connection (only if you configure it) | the URL you enter | library requests | that server |
| Image pull | `registry-1.docker.io` or your registry mirror | anonymous pull | Docker Hub, US / your mirror |

No data is sold or shared with advertisers. The update check can be reduced in the app's
settings; metadata lookups stop when you stop adding books. There is no third-party analytics
SDK and no advertising identifier.

## 7. Upstream status (vulnerability position)

Readarr's upstream repository and LinuxServer.io's image repository were **archived on
2025-06-27**. The last published image build is the one this package pins
(`linuxserver/readarr:0.3.10-develop`, built 2023-12-07, Alpine 3.18 base). Because the app
is used unmodified from the trusted registry and no newer build exists, this package cannot
apply upstream security fixes by itself. The container is limited to uid 1000, one published
port, no capabilities and no Docker socket. If a CVE affects the image, the only real fix is a
new upstream build; the developer will publish a new package iteration as soon as one exists.

## 8. Children

The app is a self-hosted utility and is not directed at children.

## 9. Changes

Material changes are published in this file and reflected in the “Last updated” date.

## 10. Contact

Moechz — **moechz@163.com** — <https://www.moechz.com/privacy.html>
