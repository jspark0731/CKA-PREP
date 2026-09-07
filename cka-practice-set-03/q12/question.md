# Q12 — Gateway API (6점)

`set_question.sh 12`가 SKIP이면 건너뛴다.

`gateway3` namespace에 HTTPRoute `web-route`를 생성하라.
- parentRefs: shared-gateway
- hostname: web.cka.local
- path prefix: /app
- backendRef: Service web, port 80
