# Q4 — HorizontalPodAutoscaler

`autoscale` namespace의 Deployment `web`에 HPA `web-hpa`를 생성하라.
- min replicas: 1
- max replicas: 4
- CPU utilization target: 50%

Metrics Server 동작 여부와 무관하게 HPA spec을 만족시키면 된다.
