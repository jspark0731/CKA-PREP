# Q14 — Scheduling Troubleshooting

`schedule-repair` namespace의 Deployment `worker-app` Pod가 Pending이다.

조건:
- replicas 2 유지
- Node의 기존 taint 제거 금지
- 잘못된 scheduling constraint를 최소 변경으로 수정
- Pod 2개 Running/Ready
