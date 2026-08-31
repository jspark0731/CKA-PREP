# Q1 — Deployment / Rolling Update (6점)

`omega` namespace에 Deployment `web`을 생성하라.

- replicas: `3`
- image: `nginx:1.27`
- container name: `nginx`
- Pod label: `app=web`
- requests: cpu `100m`, memory `64Mi`
- limits: cpu `250m`, memory `128Mi`

Deployment는 최종적으로 정상 rollout 되어야 한다.
