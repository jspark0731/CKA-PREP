# Q9 — StorageClass / PV / PVC (7점)

StorageClass `manual3`와 PV `pv3`가 준비되어 있다.

`storage3` namespace에 PVC `data`를 생성하라.
- storageClassName: manual3
- accessMode: ReadWriteOnce
- request: 3Gi

Pod `writer`에 `/data`로 mount하고 `/data/result.txt`에 `set3-storage`를 기록한 뒤 계속 실행 상태를 유지하라.
