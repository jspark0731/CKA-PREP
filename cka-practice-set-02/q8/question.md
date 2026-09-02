# Q8 — Cross-Namespace NetworkPolicy

`team-a`, `team-b`, `database` namespace가 준비되어 있다.
- team-a/client-a: `access=db`
- team-b/client-b: `access=db`
- database/db: `app=db`, nginx:80

오직 `team-a` namespace의 `access=db` Pod만 `database/db` TCP/80에 접근 가능하게 하라.
team-b/client-b는 차단되어야 한다.
