# Q15 — Composite Troubleshooting

`final2` namespace에서 `client` → `api-svc:8080` 접속이 실패한다.

구성 요소: Deployment `api`, Service `api-svc`, NetworkPolicy, client Pod.
Pod/Service/Endpoint/NetworkPolicy를 순서대로 확인하고 최소 변경으로 복구하라.
Deployment image와 replicas는 변경하지 않는다.
