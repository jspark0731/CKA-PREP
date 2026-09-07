# Q3 — Resource Requests / Scheduling (6점)

`schedule3` namespace에 Deployment `worker`를 생성하라.

- replicas: 2
- image: nginx:1.27
- requests: cpu 100m, memory 64Mi
- limits: cpu 300m, memory 128Mi
- Worker Node 하나에 `tier=compute` label 추가
- Pod는 해당 Node에만 배치

nodeSelector 또는 required nodeAffinity 사용 가능.
