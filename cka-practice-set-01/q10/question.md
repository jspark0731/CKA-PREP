# Q10 — Ingress (6점)

환경 구성 결과가 `SKIP`이면 이 문제는 건너뛴다.

`ingress-lab` namespace에는 Deployment/Service `web`이 준비되어 있다.

Ingress `web-ingress`를 생성하라.

- host: `cka.local`
- path: `/shop`
- pathType: `Prefix`
- backend Service: `web`
- backend port: `80`
- 현재 클러스터에 존재하는 ingressClassName 사용
