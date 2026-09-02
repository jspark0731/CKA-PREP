# Q5 — Taint / Toleration

Worker Node 하나에 taint `dedicated=batch:NoSchedule`를 추가하라.

Pod `batch-job`을 default namespace에 생성한다.
- image: `busybox:1.36`
- command: `sleep 3600`
- 위 taint를 tolerate
- 해당 taint가 설정된 Worker Node에 배치

필요한 label/nodeSelector는 직접 구성해도 된다.
