# Q3 — PVC / Volume Mount (7점)

`storage-lab` namespace를 생성하라.

PVC `data`:
- StorageClass: `cka-manual`
- AccessMode: `ReadWriteOnce`
- Request: `1Gi`

Pod `storage-pod`:
- image: `busybox:1.36`
- command: `sleep 3600`
- PVC `data`를 `/data`에 mount

Pod 내부에 `/data/cka.txt`를 생성하고 내용은 `persistent-data`로 한다.

> 환경 구성 스크립트가 실습용 PV와 StorageClass를 미리 준비한다.
