# Q12 — Static Pod (6점)

Control Plane Node에서 kubelet이 사용하는 Static Pod manifest 경로를 찾아라.

Static Pod:
- name: `static-nginx`
- image: `nginx:1.27`
- containerPort: `80`

정확한 manifest directory에 파일을 두고 API Server를 통해 Mirror Pod가 조회되어야 한다.
