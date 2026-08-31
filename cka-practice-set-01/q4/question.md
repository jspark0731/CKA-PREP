# Q4 — Taint / Toleration / Node Selection (7점)

Control Plane이 아닌 Worker Node 하나를 선택해:

- taint: `workload=special:NoSchedule`
- label: `workload=special`

Pod `special-app`을 `default` namespace에 생성한다.
- image: `nginx:1.27`
- 위 taint를 tolerate
- `workload=special` label이 있는 Node에만 배치

기존 taint는 제거하면 안 된다.
