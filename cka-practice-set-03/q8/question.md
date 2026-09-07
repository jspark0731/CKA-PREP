# Q8 — Cross-Namespace NetworkPolicy + Pod Selector (8점)

Namespaces: `client-a`, `client-b`, `db3`

- client-a/app: role=client
- client-b/app: role=client
- db3/database: role=db, nginx:80

오직 client-a namespace의 role=client Pod만 db3/database TCP/80 접근을 허용하라. client-b는 차단되어야 한다.
