# Q15 — Composite Service Troubleshooting (10점)

`final` namespace에 이미 다음이 있다.

Deployment `frontend`
- replicas: 3
- image: nginx:1.27
- label: app=frontend

Service `frontend-svc`
- port: 8080
- 현재 nginx 연결 실패

다음 순서로 원인을 찾아 최소 변경으로 해결하라.

1. Pod 상태
2. Service
3. Endpoint/EndpointSlice
4. nginx 실제 listen port 판단
5. 잘못된 resource 수정
6. `frontend-svc:8080`으로 접근 검증

Deployment의 nginx 설정은 변경하지 않는다.
