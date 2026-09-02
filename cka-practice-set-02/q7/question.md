# Q7 — NetworkPolicy Egress

`egress-lab` namespace의 `client(app=client)` Egress를 NetworkPolicy `client-egress`로 제한하라.

허용:
- 같은 namespace의 `web(app=web)` TCP/80
- DNS UDP/53

그 외 Egress는 허용하지 않는다. Ingress는 제한하지 않는다.
