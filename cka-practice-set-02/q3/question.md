# Q3 — Secret Environment Variables

`secret-lab` namespace에는 Secret `db-secret`이 준비되어 있다.

Pod `secret-reader`를 생성하라.
- image: `busybox:1.36`
- command: `sleep 3600`
- Secret의 모든 key를 환경변수로 주입

최종 값:
- DB_USER=admin
- DB_PASSWORD=cka-secret
