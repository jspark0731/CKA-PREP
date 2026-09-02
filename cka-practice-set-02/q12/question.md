# Q12 — Ingress

`set_question.sh 12`가 SKIP이면 건너뛴다.

`ingress2` namespace의 Service `shop`에 Ingress `shop-ingress`를 생성하라.
- 현재 IngressClass 사용
- host: shop.cka.local
- path: /
- pathType: Prefix
- backend: shop:80
