# AGENTS.md

This repository contains multiple unrelated projects. The primary/active project is
**`room-booking-app/`** (a Flutter + Node.js/Express + MySQL room booking app). The
other top-level items (`JokesApp` ASP.NET project and `c-revision-answers/` markdown)
are not part of the room-booking-app dev setup and have not been configured here.

## Cursor Cloud specific instructions

Scope: only `room-booking-app/` is set up for development in this environment.

### Services

| Service | Location | Run command | Notes |
|---------|----------|-------------|-------|
| MySQL 8.0 | system | `sudo service mysql start` | Not auto-started on boot; start it before the backend. |
| Backend API | `room-booking-app/backend` | `npm run dev` | Express API on `http://localhost:3000` (`--watch` hot-reload). Standard scripts are in `package.json`. |
| Flutter web | `room-booking-app/flutter_app` | `flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0` | Serves the app at `http://localhost:8080`. First compile takes ~15-20s. |

### Non-obvious setup/run notes

- **MySQL must be started manually** each session: `sudo service mysql start`. It is not
  enabled as a boot service.
- **MySQL auth over TCP:** the `root` user password is `rootpass` and was switched to
  `mysql_native_password` so the app can connect over TCP. The local unix socket at
  `/var/run/mysqld/mysqld.sock` is not accessible to the `ubuntu` user, so always connect
  via TCP: `mysql -uroot -prootpass -h 127.0.0.1`.
- **Backend `.env`** lives at `room-booking-app/backend/.env` (git-ignored). It points at
  `DB_HOST=127.0.0.1`, `DB_USER=root`, `DB_PASSWORD=rootpass`, `DB_NAME=room_booking_db`.
  If it is ever missing, recreate it from `backend/.env.example` with those values (use
  `127.0.0.1`, not `localhost`, to force TCP).
- **Database schema/seed:** load once with
  `mysql -uroot -prootpass -h 127.0.0.1 < room-booking-app/database/schema.sql`. This is a
  destructive re-runnable script (drops + recreates tables) that seeds the admin user
  (`admin@hotel.com` / `admin123`) and 3 sample rooms. `npm run seed` (in `backend/`) only
  re-creates the admin user.
- **Flutter SDK** is installed at `/opt/flutter` (stable channel) and added to `PATH` via
  `~/.bashrc`. If `flutter` is not found, run `export PATH="$PATH:/opt/flutter/bin"`.
  Chrome is available, so `flutter run -d chrome` also works.
- **`pubspec.lock` churn:** the installed Flutter SDK is newer than what the committed
  `pubspec.lock` was generated with, so `flutter pub get` re-resolves and shows the lockfile
  as modified. This is expected/harmless; do not commit it unless intentionally bumping deps.

### Known pre-existing app bug (not an environment issue)

The backend `GET /rooms` returns `price` as a string (e.g. `"50.00"`) because MySQL
`DECIMAL` is serialized as a string by `mysql2`. The Flutter customer/admin rooms screens
expect a numeric `price` and throw `type 'String' is not a subtype of type 'num'` when
rendering the rooms list. Login/register screens and the backend API itself work fine. This
is an application code bug, out of scope for environment setup.

### Lint / test

- Flutter: `flutter analyze` and `flutter test` (from `room-booking-app/flutter_app`).
- Backend: no lint or test scripts are defined in `backend/package.json`.
