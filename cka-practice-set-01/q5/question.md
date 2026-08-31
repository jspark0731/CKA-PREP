# Q5 — Required Node Affinity (6점)

Worker Node 하나에 label `storage=fast`를 추가하라.

` scheduling ` namespace에 Deployment `cache`를 생성한다.

- replicas: 2
- image: `nginx:1.27`
- 모든 Pod는 `storage=fast` Node에 배치
- `nodeSelector` 사용 금지
- `requiredDuringSchedulingIgnoredDuringExecution` 사용
