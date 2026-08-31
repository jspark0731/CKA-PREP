# Q8 — Cross-Namespace NetworkPolicy (8점)

환경에 다음 Pod가 이미 생성되어 있다.

`frontend-ns`
- Pod `client`
- label `role=frontend`

`database-ns`
- Pod `database`
- label `role=database`
- nginx:80

`database`로의 Ingress는 기본 차단하고, 아래 트래픽만 허용하라.

- Namespace: `frontend-ns`
- Pod label: `role=frontend`
- TCP/80

필요한 Namespace label은 직접 추가한다.
