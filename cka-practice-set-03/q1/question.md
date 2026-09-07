# Q1 — Deployment Strategy / Rollout (6점)

`rollout3` namespace에 Deployment `api`를 생성하라.

- image: `nginx:1.27` → 최종 `nginx:1.28`
- replicas: 4
- label: `app=api`
- RollingUpdate `maxUnavailable: 1`, `maxSurge: 1`
- 최종 모든 Pod Ready
