# Q11 — RBAC (7점)

`development` namespace에서 다음을 구성하라.

ServiceAccount `developer`

Role `pod-reader`:
- resources: pods
- verbs: get, list, watch

RoleBinding `developer-pod-reader`로 위 ServiceAccount에 Role을 부여한다.

검증 조건:
- pods get: 허용
- deployments delete: 거부
