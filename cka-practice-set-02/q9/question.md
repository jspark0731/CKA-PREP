# Q9 — RBAC ClusterRole + RoleBinding

`qa` namespace에서 다음 RBAC을 구성하라.

ServiceAccount: `qa-reader`
ClusterRole: `pod-log-reader`
- resources: pods, pods/log
- verbs: get, list

RoleBinding: `qa-reader-binding`
- `qa` namespace에서 위 ClusterRole을 ServiceAccount에 부여

qa namespace에서는 pod 조회/로그 조회 가능, default namespace pod 조회는 불가해야 한다.
