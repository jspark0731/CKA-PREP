# Q9 — Service Troubleshooting (7점)

`svc-test` namespace의 `api-service:8080`에 연결되지 않는다.

Deployment는 수정하면 안 된다.

원인을 찾아 Service만 수정하여:
- Endpoint/EndpointSlice가 생성되고
- `api-service:8080`으로 nginx에 접근 가능하게 하라.
