# Q10 — Static PV / PVC Binding

PV `set2-pv`와 StorageClass `set2-manual`이 준비되어 있다.

`pv-lab` namespace에 PVC `claim`:
- storageClassName: set2-manual
- RWO
- request: 2Gi

Pod `writer`:
- busybox:1.36
- sleep 3600
- PVC를 `/data`에 mount
- `/data/set2.txt` 내용 `set2-storage`
