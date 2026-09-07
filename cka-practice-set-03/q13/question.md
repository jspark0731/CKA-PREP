# Q13 — Pod Troubleshooting: Wrong Command (6점)

`repair3` namespace의 Pod `worker`가 실패 상태다. 원인을 찾아 수정하라.

최종:
- name: worker
- image: busybox:1.36
- `/tmp/ready` 파일 생성, 내용 `ready`
- 이후 sleep 3600
- Pod Ready
