#!/usr/bin/env bash
set -u
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

q1() {
echo "============================================================"
echo " CKA Practice Set #2 - Q1 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. Deployment exists"
echo "  2. replicas=3"
echo "  3. final image nginx:1.27"
echo "  4. rollout complete"
echo "  5. 3 Pods Running"
echo "  6. rollout history exists"
echo
echo "[RESULT]"
NS=rollout-lab; PASS=0; TOTAL=6
Ck(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
Ck "kubectl -n $NS get deploy web" "Deployment exists"
Ck "[ "$(kubectl -n $NS get deploy web -o jsonpath='{.spec.replicas}')" = 3 ]" "replicas=3"
Ck "[ "$(kubectl -n $NS get deploy web -o jsonpath='{.spec.template.spec.containers[0].image}')" = nginx:1.27 ]" "final image nginx:1.27"
Ck "kubectl -n $NS rollout status deploy/web --timeout=30s" "rollout complete"
Ck "[ "$(kubectl -n $NS get pods -l app=web --field-selector=status.phase=Running --no-headers | wc -l)" -eq 3 ]" "3 Pods Running"
Ck "[ "$(kubectl -n $NS get rs -l app=web --no-headers | wc -l)" -ge 2 ]" "rollout history exists"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q2() {
echo "============================================================"
echo " CKA Practice Set #2 - Q2 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. Pod web exists"
echo "  2. Pod Ready"
echo "  3. ConfigMap volume used"
echo "  4. subPath mount correct"
echo "  5. file content"
echo "  6. image"
echo
echo "[RESULT]"
NS=config-volume; PASS=0; TOTAL=6
Ck(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
Ck "kubectl -n $NS get pod web" "Pod web exists"
Ck "kubectl -n $NS wait --for=condition=Ready pod/web --timeout=30s" "Pod Ready"
Ck "kubectl -n $NS get pod web -o jsonpath='{.spec.volumes[*].configMap.name}' | grep -qw web-config" "ConfigMap volume used"
Ck "kubectl -n $NS get pod web -o jsonpath='{range .spec.containers[0].volumeMounts[*]}{.mountPath}{" "}{.subPath}{"\n"}{end}' | grep -q '^/usr/share/nginx/html/index.html index.html$'" "subPath mount correct"
Ck "[ "$(kubectl -n $NS exec web -- cat /usr/share/nginx/html/index.html 2>/dev/null)" = hello-from-configmap ]" "file content"
Ck "[ "$(kubectl -n $NS get pod web -o jsonpath='{.spec.containers[0].image}')" = nginx:1.27 ]" "image"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q3() {
echo "============================================================"
echo " CKA Practice Set #2 - Q3 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. Pod exists"
echo "  2. Pod Ready"
echo "  3. Secret referenced"
echo "  4. DB_USER"
echo "  5. DB_PASSWORD"
echo "  6. image"
echo
echo "[RESULT]"
NS=secret-lab; PASS=0; TOTAL=6
Ck(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
Ck "kubectl -n $NS get pod secret-reader" "Pod exists"
Ck "kubectl -n $NS wait --for=condition=Ready pod/secret-reader --timeout=30s" "Pod Ready"
Ck "kubectl -n $NS get pod secret-reader -o json | grep -q secretRef" "Secret referenced"
Ck "[ "$(kubectl -n $NS exec secret-reader -- sh -c 'printf %s "$DB_USER"' 2>/dev/null)" = admin ]" "DB_USER"
Ck "[ "$(kubectl -n $NS exec secret-reader -- sh -c 'printf %s "$DB_PASSWORD"' 2>/dev/null)" = cka-secret ]" "DB_PASSWORD"
Ck "[ "$(kubectl -n $NS get pod secret-reader -o jsonpath='{.spec.containers[0].image}')" = busybox:1.36 ]" "image"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q4() {
echo "============================================================"
echo " CKA Practice Set #2 - Q4 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. HPA exists"
echo "  2. target web"
echo "  3. min=1"
echo "  4. max=4"
echo "  5. CPU 50%"
echo "  6. Deployment intact"
echo
echo "[RESULT]"
NS=autoscale; PASS=0; TOTAL=6
Ck(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
Ck "kubectl -n $NS get hpa web-hpa" "HPA exists"
Ck "[ "$(kubectl -n $NS get hpa web-hpa -o jsonpath='{.spec.scaleTargetRef.name}')" = web ]" "target web"
Ck "[ "$(kubectl -n $NS get hpa web-hpa -o jsonpath='{.spec.minReplicas}')" = 1 ]" "min=1"
Ck "[ "$(kubectl -n $NS get hpa web-hpa -o jsonpath='{.spec.maxReplicas}')" = 4 ]" "max=4"
Ck "kubectl -n $NS get hpa web-hpa -o jsonpath='{.spec.metrics[0].resource.target.averageUtilization}' | grep -qx 50" "CPU 50%"
Ck "kubectl -n $NS get deploy web" "Deployment intact"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q5() {
echo "============================================================"
echo " CKA Practice Set #2 - Q5 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. batch tainted node"
echo "  2. Pod exists"
echo "  3. toleration configured"
echo "  4. scheduled to tainted node"
echo "  5. Pod Ready"
echo "  6. image"
echo
echo "[RESULT]"
PASS=0; TOTAL=6
Ck(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
NODE=$(kubectl get nodes -o json | python3 -c 'import json,sys;d=json.load(sys.stdin);print(next((x["metadata"]["name"] for x in d["items"] if any(t.get("key")=="dedicated" and t.get("value")=="batch" and t.get("effect")=="NoSchedule" for t in x["spec"].get("taints",[]))),""))')
Ck "[ -n "$NODE" ]" "batch tainted node"
Ck "kubectl get pod batch-job" "Pod exists"
Ck "kubectl get pod batch-job -o json | grep -q dedicated" "toleration configured"
Ck "[ "$(kubectl get pod batch-job -o jsonpath='{.spec.nodeName}')" = "$NODE" ]" "scheduled to tainted node"
Ck "kubectl wait --for=condition=Ready pod/batch-job --timeout=30s" "Pod Ready"
Ck "[ "$(kubectl get pod batch-job -o jsonpath='{.spec.containers[0].image}')" = busybox:1.36 ]" "image"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q6() {
echo "============================================================"
echo " CKA Practice Set #2 - Q6 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. Service exists"
echo "  2. service port 8080"
echo "  3. targetPort 80"
echo "  4. Endpoint exists"
echo "  5. service reachable"
echo "  6. image intact"
echo "  7. replicas intact"
echo
echo "[RESULT]"
NS=dns-lab; PASS=0; TOTAL=7
Ck(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
Ck "kubectl -n $NS get svc backend-svc" "Service exists"
Ck "[ "$(kubectl -n $NS get svc backend-svc -o jsonpath='{.spec.ports[0].port}')" = 8080 ]" "service port 8080"
Ck "[ "$(kubectl -n $NS get svc backend-svc -o jsonpath='{.spec.ports[0].targetPort}')" = 80 ]" "targetPort 80"
Ck "[ -n "$(kubectl -n $NS get endpoints backend-svc -o jsonpath='{.subsets[*].addresses[*].ip}')" ]" "Endpoint exists"
Ck "kubectl -n $NS exec client -- wget -q -T 5 -O- http://backend-svc:8080 >/dev/null" "service reachable"
Ck "[ "$(kubectl -n $NS get deploy backend -o jsonpath='{.spec.template.spec.containers[0].image}')" = nginx:1.27 ]" "image intact"
Ck "[ "$(kubectl -n $NS get deploy backend -o jsonpath='{.spec.replicas}')" = 2 ]" "replicas intact"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q7() {
echo "============================================================"
echo " CKA Practice Set #2 - Q7 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. NetworkPolicy exists"
echo "  2. selects client"
echo "  3. Egress policyType"
echo "  4. web allowed"
echo "  5. TCP/80 rule"
echo "  6. DNS/53 rule"
echo "  7. client->web succeeds"
echo "  8. other egress blocked"
echo
echo "[RESULT]"
NS=egress-lab; PASS=0; TOTAL=8
Ck(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
P=client-egress
Ck "kubectl -n $NS get netpol $P" "NetworkPolicy exists"
Ck "[ "$(kubectl -n $NS get netpol $P -o jsonpath='{.spec.podSelector.matchLabels.app}')" = client ]" "selects client"
Ck "kubectl -n $NS get netpol $P -o jsonpath='{.spec.policyTypes[*]}' | grep -qw Egress" "Egress policyType"
Ck "kubectl -n $NS get netpol $P -o jsonpath='{.spec.egress[*].to[*].podSelector.matchLabels.app}' | grep -qw web" "web allowed"
Ck "kubectl -n $NS get netpol $P -o json | grep -Eq '"port"[[:space:]]*:[[:space:]]*80'" "TCP/80 rule"
Ck "kubectl -n $NS get netpol $P -o json | grep -Eq '"port"[[:space:]]*:[[:space:]]*53'" "DNS/53 rule"
WIP=$(kubectl -n $NS get pod web -o jsonpath='{.status.podIP}')
Ck "kubectl -n $NS exec client -- wget -q -T 4 -O- http://$WIP >/dev/null" "client->web succeeds"
Ck "! kubectl -n $NS exec client -- wget -q -T 3 -O- http://1.1.1.1 >/dev/null 2>&1" "other egress blocked"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q8() {
echo "============================================================"
echo " CKA Practice Set #2 - Q8 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. NetworkPolicy exists"
echo "  2. selects db"
echo "  3. namespaceSelector"
echo "  4. team-a selected"
echo "  5. access=db selected"
echo "  6. port 80"
echo "  7. team-a allowed"
echo "  8. team-b blocked"
echo
echo "[RESULT]"
PASS=0; TOTAL=8
Ck(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
P=$(kubectl -n database get netpol -o name | head -1)
Ck "[ -n "$P" ]" "NetworkPolicy exists"
Ck "[ "$(kubectl -n database get $P -o jsonpath='{.spec.podSelector.matchLabels.app}')" = db ]" "selects db"
Ck "kubectl -n database get $P -o json | grep -q namespaceSelector" "namespaceSelector"
Ck "kubectl -n database get $P -o json | grep -q team-a" "team-a selected"
Ck "kubectl -n database get $P -o jsonpath='{.spec.ingress[*].from[*].podSelector.matchLabels.access}' | grep -qw db" "access=db selected"
Ck "kubectl -n database get $P -o jsonpath='{.spec.ingress[*].ports[*].port}' | grep -qw 80" "port 80"
DIP=$(kubectl -n database get pod db -o jsonpath='{.status.podIP}')
Ck "kubectl -n team-a exec client-a -- wget -q -T 4 -O- http://$DIP >/dev/null" "team-a allowed"
Ck "! kubectl -n team-b exec client-b -- wget -q -T 3 -O- http://$DIP >/dev/null 2>&1" "team-b blocked"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q9() {
echo "============================================================"
echo " CKA Practice Set #2 - Q9 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. ServiceAccount"
echo "  2. ClusterRole"
echo "  3. RoleBinding"
echo "  4. qa pods get"
echo "  5. qa logs get"
echo "  6. default denied"
echo "  7. RoleBinding->ClusterRole"
echo
echo "[RESULT]"
NS=qa; PASS=0; TOTAL=7
Ck(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
Ck "kubectl -n $NS get sa qa-reader" "ServiceAccount"
Ck "kubectl get clusterrole pod-log-reader" "ClusterRole"
Ck "kubectl -n $NS get rolebinding qa-reader-binding" "RoleBinding"
Ck "kubectl auth can-i get pods -n $NS --as=system:serviceaccount:$NS:qa-reader | grep -qx yes" "qa pods get"
Ck "kubectl auth can-i get pods/log -n $NS --as=system:serviceaccount:$NS:qa-reader | grep -qx yes" "qa logs get"
Ck "kubectl auth can-i get pods -n default --as=system:serviceaccount:$NS:qa-reader | grep -qx no" "default denied"
Ck "[ "$(kubectl -n $NS get rolebinding qa-reader-binding -o jsonpath='{.roleRef.kind}')" = ClusterRole ]" "RoleBinding->ClusterRole"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q10() {
echo "============================================================"
echo " CKA Practice Set #2 - Q10 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. PVC exists"
echo "  2. StorageClass"
echo "  3. request 2Gi"
echo "  4. RWO"
echo "  5. mount /data"
echo "  6. Pod Ready"
echo "  7. file content"
echo
echo "[RESULT]"
NS=pv-lab; PASS=0; TOTAL=7
Ck(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
Ck "kubectl -n $NS get pvc claim" "PVC exists"
Ck "[ "$(kubectl -n $NS get pvc claim -o jsonpath='{.spec.storageClassName}')" = set2-manual ]" "StorageClass"
Ck "[ "$(kubectl -n $NS get pvc claim -o jsonpath='{.spec.resources.requests.storage}')" = 2Gi ]" "request 2Gi"
Ck "kubectl -n $NS get pvc claim -o jsonpath='{.spec.accessModes[*]}' | grep -qw ReadWriteOnce" "RWO"
Ck "kubectl -n $NS get pod writer -o jsonpath='{range .spec.containers[0].volumeMounts[*]}{.name}{"="}{.mountPath}{"\n"}{end}' | grep -q '=/data$'" "mount /data"
Ck "kubectl -n $NS wait --for=condition=Ready pod/writer --timeout=30s" "Pod Ready"
Ck "[ "$(kubectl -n $NS exec writer -- cat /data/set2.txt 2>/dev/null)" = set2-storage ]" "file content"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q11() {
echo "============================================================"
echo " CKA Practice Set #2 - Q11 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. overlay exists"
echo "  2. kustomize builds"
echo "  3. namespace"
echo "  4. namePrefix"
echo "  5. image"
echo "  6. replicas"
echo "  7. deploys"
echo
echo "[RESULT]"
PASS=0; TOTAL=7
Ck(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
Ck "[ -f "$ROOT_DIR/q11/overlay/kustomization.yaml" ]" "overlay exists"
Ck "kubectl kustomize "$ROOT_DIR/q11/overlay" >/dev/null" "kustomize builds"
OUT=$(kubectl kustomize "$ROOT_DIR/q11/overlay" 2>/dev/null)
Ck "printf '%s\n' "$OUT" | grep -q 'namespace: kustomize-lab'" "namespace"
Ck "printf '%s\n' "$OUT" | grep -q 'name: prod-web'" "namePrefix"
Ck "printf '%s\n' "$OUT" | grep -q 'image: nginx:1.27'" "image"
Ck "printf '%s\n' "$OUT" | grep -q 'replicas: 3'" "replicas"
Ck "kubectl apply -k "$ROOT_DIR/q11/overlay" >/dev/null && kubectl -n kustomize-lab rollout status deploy/prod-web --timeout=40s >/dev/null" "deploys"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q12() {
echo "============================================================"
echo " CKA Practice Set #2 - Q12 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. Ingress exists"
echo "  2. IngressClass"
echo "  3. host"
echo "  4. path"
echo "  5. pathType"
echo "  6. backend"
echo
echo "[RESULT]"
CLS=$(kubectl get ingressclass -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true); if [ -z "$CLS" ]; then echo "[SKIP] No IngressClass"; return 0; fi
NS=ingress2; PASS=0; TOTAL=6
Ck(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
Ck "kubectl -n $NS get ingress shop-ingress" "Ingress exists"
Ck "[ "$(kubectl -n $NS get ingress shop-ingress -o jsonpath='{.spec.ingressClassName}')" = "$CLS" ]" "IngressClass"
Ck "[ "$(kubectl -n $NS get ingress shop-ingress -o jsonpath='{.spec.rules[0].host}')" = shop.cka.local ]" "host"
Ck "[ "$(kubectl -n $NS get ingress shop-ingress -o jsonpath='{.spec.rules[0].http.paths[0].path}')" = / ]" "path"
Ck "[ "$(kubectl -n $NS get ingress shop-ingress -o jsonpath='{.spec.rules[0].http.paths[0].pathType}')" = Prefix ]" "pathType"
Ck "[ "$(kubectl -n $NS get ingress shop-ingress -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.name}')" = shop ]" "backend"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q13() {
echo "============================================================"
echo " CKA Practice Set #2 - Q13 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. Pod exists"
echo "  2. image"
echo "  3. Pod Ready"
echo "  4. APP_MODE"
echo "  5. ConfigMap ref"
echo "  6. correct key"
echo
echo "[RESULT]"
NS=repair2; PASS=0; TOTAL=6
Ck(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
Ck "kubectl -n $NS get pod app" "Pod exists"
Ck "[ "$(kubectl -n $NS get pod app -o jsonpath='{.spec.containers[0].image}')" = busybox:1.36 ]" "image"
Ck "kubectl -n $NS wait --for=condition=Ready pod/app --timeout=30s" "Pod Ready"
Ck "[ "$(kubectl -n $NS exec app -- sh -c 'printf %s "$APP_MODE"' 2>/dev/null)" = production ]" "APP_MODE"
Ck "[ "$(kubectl -n $NS get pod app -o jsonpath='{.spec.containers[0].env[0].valueFrom.configMapKeyRef.name}')" = app-config ]" "ConfigMap ref"
Ck "[ "$(kubectl -n $NS get pod app -o jsonpath='{.spec.containers[0].env[0].valueFrom.configMapKeyRef.key}')" = APP_MODE ]" "correct key"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q14() {
echo "============================================================"
echo " CKA Practice Set #2 - Q14 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. Deployment exists"
echo "  2. replicas=2"
echo "  3. bad selector fixed"
echo "  4. image intact"
echo "  5. rollout complete"
echo "  6. 2 Pods Running"
echo "  7. 2 Pods Ready"
echo
echo "[RESULT]"
NS=schedule-repair; PASS=0; TOTAL=7
Ck(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
Ck "kubectl -n $NS get deploy worker-app" "Deployment exists"
Ck "[ "$(kubectl -n $NS get deploy worker-app -o jsonpath='{.spec.replicas}')" = 2 ]" "replicas=2"
Ck "! kubectl -n $NS get deploy worker-app -o jsonpath='{.spec.template.spec.nodeSelector.impossible-label}' | grep -q does-not-exist" "bad selector fixed"
Ck "[ "$(kubectl -n $NS get deploy worker-app -o jsonpath='{.spec.template.spec.containers[0].image}')" = nginx:1.27 ]" "image intact"
Ck "kubectl -n $NS rollout status deploy/worker-app --timeout=40s" "rollout complete"
Ck "[ "$(kubectl -n $NS get pods -l app=worker-app --field-selector=status.phase=Running --no-headers | wc -l)" -eq 2 ]" "2 Pods Running"
Ck "[ "$(kubectl -n $NS get pods -l app=worker-app -o jsonpath='{range .items[*]}{.status.containerStatuses[0].ready}{"\n"}{end}' | grep -c true)" -eq 2 ]" "2 Pods Ready"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q15() {
echo "============================================================"
echo " CKA Practice Set #2 - Q15 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. Deployment exists"
echo "  2. replicas intact"
echo "  3. image intact"
echo "  4. service port"
echo "  5. targetPort"
echo "  6. Endpoint exists"
echo "  7. NetworkPolicy retained"
echo "  8. client allowed"
echo "  9. policy port 80"
echo "  10. service reachable"
echo
echo "[RESULT]"
NS=final2; PASS=0; TOTAL=10
Ck(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
Ck "kubectl -n $NS get deploy api" "Deployment exists"
Ck "[ "$(kubectl -n $NS get deploy api -o jsonpath='{.spec.replicas}')" = 2 ]" "replicas intact"
Ck "[ "$(kubectl -n $NS get deploy api -o jsonpath='{.spec.template.spec.containers[0].image}')" = nginx:1.27 ]" "image intact"
Ck "[ "$(kubectl -n $NS get svc api-svc -o jsonpath='{.spec.ports[0].port}')" = 8080 ]" "service port"
Ck "[ "$(kubectl -n $NS get svc api-svc -o jsonpath='{.spec.ports[0].targetPort}')" = 80 ]" "targetPort"
Ck "[ -n "$(kubectl -n $NS get endpoints api-svc -o jsonpath='{.subsets[*].addresses[*].ip}')" ]" "Endpoint exists"
Ck "kubectl -n $NS get netpol api-ingress" "NetworkPolicy retained"
Ck "kubectl -n $NS get netpol api-ingress -o jsonpath='{.spec.ingress[*].from[*].podSelector.matchLabels.app}' | grep -qw client" "client allowed"
Ck "kubectl -n $NS get netpol api-ingress -o jsonpath='{.spec.ingress[*].ports[*].port}' | grep -qw 80" "policy port 80"
Ck "kubectl -n $NS exec client -- wget -q -T 5 -O- http://api-svc:8080 >/dev/null" "service reachable"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

if [ "$#" -ne 1 ]; then echo "Usage: $0 <question-number>"; exit 1; fi
case "$1" in
  1) q1 ;;
  2) q2 ;;
  3) q3 ;;
  4) q4 ;;
  5) q5 ;;
  6) q6 ;;
  7) q7 ;;
  8) q8 ;;
  9) q9 ;;
  10) q10 ;;
  11) q11 ;;
  12) q12 ;;
  13) q13 ;;
  14) q14 ;;
  15) q15 ;;
  *) echo "Unknown question: $1"; exit 1 ;;
esac
