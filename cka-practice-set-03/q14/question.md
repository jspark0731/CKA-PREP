# Q14 — Static Pod + Manifest Path (6점)

Control Plane에서 kubelet의 staticPodPath를 확인하라.

Static Pod:
- name: audit-web
- image: nginx:1.27
- containerPort: 80
- 실제 staticPodPath에 manifest 저장
- Mirror Pod가 API Server에서 보여야 함
