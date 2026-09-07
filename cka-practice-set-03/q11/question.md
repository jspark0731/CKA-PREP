# Q11 — CRD / Custom Resource (7점)

CRD `backups.example.com`이 준비되어 있다.

Custom Resource 생성:
- apiVersion: example.com/v1
- kind: Backup
- name: daily-backup
- namespace: crd3
- spec.schedule: `0 2 * * *`
- spec.retention: 7
