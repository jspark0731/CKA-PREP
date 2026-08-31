# Q7 — Selective Ingress NetworkPolicy (8점)

`network-a`에 이미 frontend/backend/random Pod와 default-deny 정책이 구성되어 있다.

`backend`에 대해 오직 아래 Ingress만 허용하라.

- source Pod: `app=frontend`
- destination Pod: `app=backend`
- protocol: TCP
- port: 80

`random` → `backend:80`은 실패해야 한다.
기존 `deny-all-ingress`는 삭제하지 않는다.
