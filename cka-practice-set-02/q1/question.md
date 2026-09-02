# Q1 — Deployment Rollout / Rollback

`rollout-lab` namespace에는 Deployment `web`이 준비되어 있다.

1. image를 `nginx:1.27`로 변경하고 rollout을 완료한다.
2. image를 `nginx:does-not-exist-cka`로 변경하여 rollout 실패를 만든다.
3. 이전 정상 revision으로 rollback 한다.

최종 조건:
- replicas: 3
- image: `nginx:1.27`
- 모든 Pod Ready
