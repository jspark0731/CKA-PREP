# Q11 — Kustomize Overlay

`q11/base`에 Deployment/Service base manifest가 준비되어 있다. `q11/overlay`를 완성하라.

최종 조건:
- namespace: kustomize-lab
- namePrefix: prod-
- Deployment image: nginx:1.27
- replicas: 3
- `kubectl apply -k q11/overlay` 가능
