# Q2 — ConfigMap + Secret Mixed Injection (6점)

`mixed-config` namespace에 ConfigMap `app-config`와 Secret `app-secret`이 준비되어 있다.

Pod `mixed-reader`를 생성하라.
- image: busybox:1.36
- command: sleep 3600
- ConfigMap은 `envFrom`으로 전체 주입
- Secret은 `env.valueFrom.secretKeyRef`로 `API_KEY`만 주입
- APP_MODE=production, LOG_LEVEL=info, API_KEY=cka-key 확인
