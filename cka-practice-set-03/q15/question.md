# Q15 — Composite Troubleshooting (10점)

`final3` namespace의 client에서 `api-svc:8080` 접근이 실패한다. 문제는 두 군데다.

확인 순서:
1. Pod
2. Service selector/Endpoint
3. port/targetPort
4. NetworkPolicy selector/source
5. 실제 통신

Deployment image와 replicas는 수정하지 않고 최소 변경으로 복구하라.
