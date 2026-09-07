# Q5 — RBAC: ClusterRole Reuse (7점)

`dev-a`, `dev-b` namespace에 각각 ServiceAccount `dev-reader`를 생성하라.
ClusterRole `config-reader`는 configmaps에 get,list 권한을 가진다.
각 namespace에 RoleBinding을 생성하여 자기 namespace에서만 권한을 사용하게 하라.

- dev-a SA → dev-a configmaps get: yes
- dev-a SA → dev-b configmaps get: no
- dev-b SA → dev-b configmaps get: yes
