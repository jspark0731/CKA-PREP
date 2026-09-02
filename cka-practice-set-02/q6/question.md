# Q6 — Service DNS Troubleshooting

`dns-lab` namespace에 `backend` Deployment, `backend-svc` Service, `client` Pod가 준비되어 있다.
현재 `client`에서 `http://backend-svc:8080` 접속이 실패한다.

Deployment는 수정하지 말고 Service를 복구하라.
최종 조건:
- Service port 8080
- nginx 실제 listen port로 전달
- Endpoint 존재
- client에서 접속 성공
