# Q10 — Kustomize Overlay with Patch (7점)

`q10/base`는 수정하지 않는다. `q10/overlay`를 완성하라.

최종:
- namespace: kustom3
- namePrefix: stage-
- Deployment replicas: 2
- image: nginx:1.28
- Pod label `env=stage` 추가
- Service selector 정상 매칭
- `kubectl apply -k q10/overlay` 성공
