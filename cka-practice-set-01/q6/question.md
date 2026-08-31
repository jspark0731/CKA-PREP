# Q6 — NetworkPolicy Default Deny (6점)

`network-a` namespace에 다음 Pod를 준비한다.

- frontend: `app=frontend`
- backend: `app=backend`
- random: `app=random`

이미지는 모두 `nginx:1.27`.

NetworkPolicy `deny-all-ingress`를 만들어 namespace의 모든 Pod에 대한 Ingress를 기본 차단한다.

Egress는 제한하지 않는다.
