# Q4 — HPA + Resource Preconditions (6점)

`hpa3` namespace의 Deployment `web`에 HPA `web-hpa`를 구성하라.

- minReplicas: 2
- maxReplicas: 5
- CPU average utilization: 60%
- Deployment container에 CPU request가 반드시 존재
