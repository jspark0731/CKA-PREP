# Q2 — ConfigMap / Secret (5점)

`app-config` namespace를 생성하라.

ConfigMap `runtime-config`:
- `APP_MODE=production`
- `LOG_LEVEL=warning`

Secret `db-credentials`:
- `DB_USER=ckauser`
- `DB_PASSWORD=cka-pass-2026`

Pod `config-reader`:
- image: `busybox:1.36`
- command: `sleep 3600`
- 위 4개 값을 환경변수로 주입한다.
