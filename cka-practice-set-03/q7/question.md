# Q7 — NetworkPolicy: Ingress + DNS-Aware Egress (8점)

`net3` namespace의 frontend/backend/random Pod를 대상으로 정책을 구성하라.

frontend:
- Egress 기본 제한
- backend TCP/80 허용
- DNS UDP/53 허용

backend:
- Ingress는 frontend TCP/80만 허용

최종: frontend→backend 성공, random→backend 실패
