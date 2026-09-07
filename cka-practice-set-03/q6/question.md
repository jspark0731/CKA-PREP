# Q6 — Service Troubleshooting: Selector + Port (7점)

`svc3` namespace의 `web-svc`는 두 군데가 잘못되어 있다.
Deployment는 수정하지 말고 Service만 복구하라.

- Service port: 8080
- targetPort: nginx 실제 listen port
- selector가 Pod label과 일치
- EndpointSlice 주소 존재
- client에서 `http://web-svc:8080` 접근 성공
