# Q2 — ConfigMap Volume Mount

`config-volume` namespace에는 ConfigMap `web-config`가 준비되어 있다.

Pod `web`을 생성하라.
- image: `nginx:1.27`
- ConfigMap key `index.html`을 `/usr/share/nginx/html/index.html`에 mount
- 기존 디렉터리 전체를 덮지 않도록 `subPath` 사용

최종 파일 내용: `hello-from-configmap`
