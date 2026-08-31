#!/usr/bin/env bash
set -u

q1() {
echo "============================================================"
echo " Q1 VALIDATION"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  - Final cluster state checks for this question"
echo
echo "[RESULT]"
NS=omega; PASS=0; TOTAL=8
ok(){ PASS=$((PASS+1)); echo "[PASS] $1"; }
ng(){ echo "[FAIL] $1"; }
testcmd(){ if eval "$1" >/dev/null 2>&1; then ok "$2"; else ng "$2"; fi; }

testcmd "kubectl get ns $NS" "namespace omega"
testcmd "kubectl -n $NS get deploy web" "deployment web exists"
testcmd "[ \"$(kubectl -n $NS get deploy web -o jsonpath='{.spec.replicas}' 2>/dev/null)\" = 3 ]" "replicas=3"
testcmd "[ \"$(kubectl -n $NS get deploy web -o jsonpath='{.spec.template.metadata.labels.app}' 2>/dev/null)\" = web ]" "pod label app=web"
testcmd "[ \"$(kubectl -n $NS get deploy web -o jsonpath='{.spec.template.spec.containers[0].name}' 2>/dev/null)\" = nginx ] && [ \"$(kubectl -n $NS get deploy web -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)\" = nginx:1.27 ]" "container name/image"
testcmd "[ \"$(kubectl -n $NS get deploy web -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}' 2>/dev/null)\" = 100m ] && [ \"$(kubectl -n $NS get deploy web -o jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}' 2>/dev/null)\" = 64Mi ]" "resource requests"
testcmd "[ \"$(kubectl -n $NS get deploy web -o jsonpath='{.spec.template.spec.containers[0].resources.limits.cpu}' 2>/dev/null)\" = 250m ] && [ \"$(kubectl -n $NS get deploy web -o jsonpath='{.spec.template.spec.containers[0].resources.limits.memory}' 2>/dev/null)\" = 128Mi ]" "resource limits"
testcmd "kubectl -n $NS rollout status deploy/web --timeout=20s" "rollout complete"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q2() {
echo "============================================================"
echo " Q2 VALIDATION"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. namespace"
echo "  2. ConfigMap values"
echo "  3. Secret values"
echo "  4. Pod exists"
echo "  5. Pod Ready"
echo "  6. environment values"
echo
echo "[RESULT]"
NS=app-config; PASS=0; TOTAL=6
C(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
C "kubectl get ns $NS" "namespace"
C "[ \"$(kubectl -n $NS get cm runtime-config -o jsonpath='{.data.APP_MODE}' 2>/dev/null)\" = production ] && [ \"$(kubectl -n $NS get cm runtime-config -o jsonpath='{.data.LOG_LEVEL}' 2>/dev/null)\" = warning ]" "ConfigMap values"
C "[ \"$(kubectl -n $NS get secret db-credentials -o jsonpath='{.data.DB_USER}' 2>/dev/null | base64 -d)\" = ckauser ] && [ \"$(kubectl -n $NS get secret db-credentials -o jsonpath='{.data.DB_PASSWORD}' 2>/dev/null | base64 -d)\" = cka-pass-2026 ]" "Secret values"
C "kubectl -n $NS get pod config-reader" "Pod exists"
C "kubectl -n $NS wait --for=condition=Ready pod/config-reader --timeout=30s" "Pod Ready"
C "[ \"$(kubectl -n $NS exec config-reader -- sh -c 'printf %s \"$APP_MODE\"' 2>/dev/null)\" = production ] && [ \"$(kubectl -n $NS exec config-reader -- sh -c 'printf %s \"$LOG_LEVEL\"' 2>/dev/null)\" = warning ] && [ \"$(kubectl -n $NS exec config-reader -- sh -c 'printf %s \"$DB_USER\"' 2>/dev/null)\" = ckauser ] && [ \"$(kubectl -n $NS exec config-reader -- sh -c 'printf %s \"$DB_PASSWORD\"' 2>/dev/null)\" = cka-pass-2026 ]" "environment values"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q3() {
echo "============================================================"
echo " Q3 VALIDATION"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. namespace"
echo "  2. storageClass"
echo "  3. request 1Gi"
echo "  4. RWO"
echo "  5. mountPath /data"
echo "  6. Pod Ready"
echo "  7. file content"
echo
echo "[RESULT]"
NS=storage-lab; PASS=0; TOTAL=7
C(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
C "kubectl get ns $NS" "namespace"
C "[ \"$(kubectl -n $NS get pvc data -o jsonpath='{.spec.storageClassName}' 2>/dev/null)\" = cka-manual ]" "storageClass"
C "[ \"$(kubectl -n $NS get pvc data -o jsonpath='{.spec.resources.requests.storage}' 2>/dev/null)\" = 1Gi ]" "request 1Gi"
C "kubectl -n $NS get pvc data -o jsonpath='{.spec.accessModes[*]}' 2>/dev/null | grep -qw ReadWriteOnce" "RWO"
C "[ \"$(kubectl -n $NS get pod storage-pod -o jsonpath='{.spec.containers[0].volumeMounts[?(@.mountPath==\"/data\")].mountPath}' 2>/dev/null)\" = /data ]" "mountPath /data"
C "kubectl -n $NS wait --for=condition=Ready pod/storage-pod --timeout=30s" "Pod Ready"
C "[ \"$(kubectl -n $NS exec storage-pod -- cat /data/cka.txt 2>/dev/null)\" = persistent-data ]" "file content"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q4() {
echo "============================================================"
echo " Q4 VALIDATION"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. special labeled node exists"
echo "  2. taint set"
echo "  3. pod exists"
echo "  4. image"
echo "  5. toleration present"
echo "  6. scheduled to labeled node"
echo "  7. Pod Ready"
echo
echo "[RESULT]"
PASS=0; TOTAL=7
C(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
NODE=$(kubectl get nodes -l workload=special -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
C "[ -n \"$NODE\" ]" "special labeled node exists"
C "kubectl describe node \"$NODE\" 2>/dev/null | grep -q 'workload=special:NoSchedule'" "taint set"
C "kubectl get pod special-app" "pod exists"
C "[ \"$(kubectl get pod special-app -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)\" = nginx:1.27 ]" "image"
C "kubectl get pod special-app -o jsonpath='{.spec.tolerations[*].key}' 2>/dev/null | grep -qw workload" "toleration present"
C "[ \"$(kubectl get pod special-app -o jsonpath='{.spec.nodeName}' 2>/dev/null)\" = \"$NODE\" ]" "scheduled to labeled node"
C "kubectl wait --for=condition=Ready pod/special-app --timeout=30s" "Pod Ready"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q5() {
echo "============================================================"
echo " Q5 VALIDATION"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. storage=fast node"
echo "  2. deployment exists"
echo "  3. replicas=2"
echo "  4. nodeSelector unused"
echo "  5. required nodeAffinity"
echo "  6. all pods on fast node"
echo
echo "[RESULT]"
NS=scheduling; PASS=0; TOTAL=6
C(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
NODE=$(kubectl get nodes -l storage=fast -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
C "[ -n \"$NODE\" ]" "storage=fast node"
C "kubectl -n $NS get deploy cache" "deployment exists"
C "[ \"$(kubectl -n $NS get deploy cache -o jsonpath='{.spec.replicas}' 2>/dev/null)\" = 2 ]" "replicas=2"
C "[ -z \"$(kubectl -n $NS get deploy cache -o jsonpath='{.spec.template.spec.nodeSelector}' 2>/dev/null)\" ]" "nodeSelector unused"
C "kubectl -n $NS get deploy cache -o json | grep -q requiredDuringSchedulingIgnoredDuringExecution" "required nodeAffinity"
C "[ \"$(kubectl -n $NS get pods -l app=cache -o jsonpath='{range .items[*]}{.spec.nodeName}{\"\\n\"}{end}' 2>/dev/null | sort -u)\" = \"$NODE\" ]" "all pods on fast node"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q6() {
echo "============================================================"
echo " Q6 VALIDATION"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. policy exists"
echo "  2. selects all pods"
echo "  3. Ingress policyType"
echo "  4. Egress not restricted"
echo "  5. no ingress allow rules"
echo "  6. lab pods intact"
echo
echo "[RESULT]"
NS=network-a; PASS=0; TOTAL=6
C(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
C "kubectl -n $NS get netpol deny-all-ingress" "policy exists"
C "[ \"$(kubectl -n $NS get netpol deny-all-ingress -o jsonpath='{.spec.podSelector}' 2>/dev/null)\" = 'map[]' ]" "selects all pods"
C "kubectl -n $NS get netpol deny-all-ingress -o jsonpath='{.spec.policyTypes[*]}' 2>/dev/null | grep -qw Ingress" "Ingress policyType"
C "! kubectl -n $NS get netpol deny-all-ingress -o jsonpath='{.spec.policyTypes[*]}' 2>/dev/null | grep -qw Egress" "Egress not restricted"
C "[ \"$(kubectl -n $NS get netpol deny-all-ingress -o jsonpath='{.spec.ingress}' 2>/dev/null)\" = '[]' ] || [ -z \"$(kubectl -n $NS get netpol deny-all-ingress -o jsonpath='{.spec.ingress}' 2>/dev/null)\" ]" "no ingress allow rules"
C "[ \"$(kubectl -n $NS get pods --no-headers 2>/dev/null | wc -l)\" -ge 3 ]" "lab pods intact"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q7() {
echo "============================================================"
echo " Q7 VALIDATION"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. default deny retained"
echo "  2. additional allow policy exists"
echo "  3. selects backend"
echo "  4. source frontend"
echo "  5. port 80"
echo "  6. protocol TCP"
echo "  7. frontend -> backend succeeds"
echo "  8. random -> backend blocked"
echo
echo "[RESULT]"
NS=network-a; PASS=0; TOTAL=8
C(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
POL=$(kubectl -n $NS get netpol -o name 2>/dev/null | grep -v deny-all-ingress | head -1)
C "kubectl -n $NS get netpol deny-all-ingress" "default deny retained"
C "[ -n \"$POL\" ]" "additional allow policy exists"
if [ -n "$POL" ]; then
  C "[ \"$(kubectl -n $NS get $POL -o jsonpath='{.spec.podSelector.matchLabels.app}' 2>/dev/null)\" = backend ]" "selects backend"
  C "kubectl -n $NS get $POL -o jsonpath='{.spec.ingress[*].from[*].podSelector.matchLabels.app}' 2>/dev/null | grep -qw frontend" "source frontend"
  C "kubectl -n $NS get $POL -o jsonpath='{.spec.ingress[*].ports[*].port}' 2>/dev/null | grep -qw 80" "port 80"
  C "kubectl -n $NS get $POL -o jsonpath='{.spec.ingress[*].ports[*].protocol}' 2>/dev/null | grep -qw TCP" "protocol TCP"
else
  echo "[FAIL] selects backend"; echo "[FAIL] source frontend"; echo "[FAIL] port 80"; echo "[FAIL] protocol TCP"
fi
BIP=$(kubectl -n $NS get pod backend -o jsonpath='{.status.podIP}' 2>/dev/null)
C "kubectl -n $NS exec frontend -- sh -c 'wget -q -T 3 -O- http://$BIP >/dev/null'" "frontend -> backend succeeds"
C "! kubectl -n $NS exec random -- sh -c 'wget -q -T 3 -O- http://$BIP >/dev/null' >/dev/null 2>&1" "random -> backend blocked"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q8() {
echo "============================================================"
echo " Q8 VALIDATION"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. NetworkPolicy exists"
echo "  2. selects database"
echo "  3. frontend namespace labeled"
echo "  4. namespaceSelector used"
echo "  5. podSelector role=frontend"
echo "  6. port 80"
echo "  7. frontend namespace allowed"
echo "  8. other namespace blocked"
echo
echo "[RESULT]"
PASS=0; TOTAL=8
C(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
POL=$(kubectl -n database-ns get netpol -o name 2>/dev/null | head -1)
C "[ -n \"$POL\" ]" "NetworkPolicy exists"
C "[ \"$(kubectl -n database-ns get $POL -o jsonpath='{.spec.podSelector.matchLabels.role}' 2>/dev/null)\" = database ]" "selects database"
C "[ -n \"$(kubectl get ns frontend-ns -o jsonpath='{.metadata.labels}' 2>/dev/null)\" ]" "frontend namespace labeled"
C "kubectl -n database-ns get $POL -o json | grep -q namespaceSelector" "namespaceSelector used"
C "kubectl -n database-ns get $POL -o jsonpath='{.spec.ingress[*].from[*].podSelector.matchLabels.role}' 2>/dev/null | grep -qw frontend" "podSelector role=frontend"
C "kubectl -n database-ns get $POL -o jsonpath='{.spec.ingress[*].ports[*].port}' 2>/dev/null | grep -qw 80" "port 80"
DIP=$(kubectl -n database-ns get pod database -o jsonpath='{.status.podIP}' 2>/dev/null)
C "kubectl -n frontend-ns exec client -- sh -c 'wget -q -T 3 -O- http://$DIP >/dev/null'" "frontend namespace allowed"
C "! kubectl -n other-ns exec outsider -- sh -c 'wget -q -T 3 -O- http://$DIP >/dev/null' >/dev/null 2>&1" "other namespace blocked"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q9() {
echo "============================================================"
echo " Q9 VALIDATION"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. selector fixed"
echo "  2. service port 8080"
echo "  3. targetPort 80"
echo "  4. Endpoint exists"
echo "  5. EndpointSlice exists"
echo "  6. service reachable"
echo "  7. deployment intact"
echo
echo "[RESULT]"
NS=svc-test; PASS=0; TOTAL=7
C(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
C "[ \"$(kubectl -n $NS get svc api-service -o jsonpath='{.spec.selector.app}' 2>/dev/null)\" = api ]" "selector fixed"
C "[ \"$(kubectl -n $NS get svc api-service -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)\" = 8080 ]" "service port 8080"
C "[ \"$(kubectl -n $NS get svc api-service -o jsonpath='{.spec.ports[0].targetPort}' 2>/dev/null)\" = 80 ]" "targetPort 80"
C "[ -n \"$(kubectl -n $NS get endpoints api-service -o jsonpath='{.subsets[*].addresses[*].ip}' 2>/dev/null)\" ]" "Endpoint exists"
C "kubectl -n $NS get endpointslice -l kubernetes.io/service-name=api-service >/dev/null 2>&1" "EndpointSlice exists"
C "kubectl -n $NS exec client -- wget -q -T 5 -O- http://api-service:8080 >/dev/null" "service reachable"
C "[ \"$(kubectl -n $NS get deploy api-server -o jsonpath='{.spec.template.metadata.labels.app}' 2>/dev/null)\" = api ]" "deployment intact"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q10() {
echo "============================================================"
echo " Q10 VALIDATION"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. Ingress exists"
echo "  2. ingressClassName"
echo "  3. host"
echo "  4. path"
echo "  5. pathType"
echo "  6. backend"
echo
echo "[RESULT]"
NS=ingress-lab
CLS=$(kubectl get ingressclass -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)
if [ -z "$CLS" ]; then echo "[SKIP] No IngressClass"; exit 0; fi
PASS=0; TOTAL=6
C(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
C "kubectl -n $NS get ingress web-ingress" "Ingress exists"
C "[ \"$(kubectl -n $NS get ingress web-ingress -o jsonpath='{.spec.ingressClassName}' 2>/dev/null)\" = \"$CLS\" ]" "ingressClassName"
C "[ \"$(kubectl -n $NS get ingress web-ingress -o jsonpath='{.spec.rules[0].host}' 2>/dev/null)\" = cka.local ]" "host"
C "[ \"$(kubectl -n $NS get ingress web-ingress -o jsonpath='{.spec.rules[0].http.paths[0].path}' 2>/dev/null)\" = /shop ]" "path"
C "[ \"$(kubectl -n $NS get ingress web-ingress -o jsonpath='{.spec.rules[0].http.paths[0].pathType}' 2>/dev/null)\" = Prefix ]" "pathType"
C "[ \"$(kubectl -n $NS get ingress web-ingress -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.name}' 2>/dev/null)\" = web ] && [ \"$(kubectl -n $NS get ingress web-ingress -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.port.number}' 2>/dev/null)\" = 80 ]" "backend"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q11() {
echo "============================================================"
echo " Q11 VALIDATION"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. ServiceAccount"
echo "  2. Role"
echo "  3. RoleBinding"
echo "  4. pods resource"
echo "  5. get/list/watch verbs"
echo "  6. can get pods"
echo "  7. cannot delete deployments"
echo
echo "[RESULT]"
NS=development; PASS=0; TOTAL=7
C(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
C "kubectl -n $NS get sa developer" "ServiceAccount"
C "kubectl -n $NS get role pod-reader" "Role"
C "kubectl -n $NS get rolebinding developer-pod-reader" "RoleBinding"
C "kubectl -n $NS get role pod-reader -o jsonpath='{.rules[0].resources[*]}' | grep -qw pods" "pods resource"
C "for v in get list watch; do kubectl -n $NS get role pod-reader -o jsonpath='{.rules[0].verbs[*]}' | grep -qw \$v || exit 1; done" "get/list/watch verbs"
C "kubectl auth can-i get pods -n $NS --as=system:serviceaccount:$NS:developer | grep -qx yes" "can get pods"
C "kubectl auth can-i delete deployments -n $NS --as=system:serviceaccount:$NS:developer | grep -qx no" "cannot delete deployments"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q12() {
echo "============================================================"
echo " Q12 VALIDATION"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. manifest in staticPodPath"
echo "  2. image"
echo "  3. containerPort"
echo "  4. mirror Pod visible"
echo "  5. static source=file"
echo "  6. Pod Running"
echo
echo "[RESULT]"
PASS=0; TOTAL=6
DIR=$(awk '/staticPodPath:/ {print $2}' /var/lib/kubelet/config.yaml 2>/dev/null || true)
[ -z "$DIR" ] && DIR=/etc/kubernetes/manifests
C(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
FILE=$(grep -rl 'name: static-nginx' "$DIR" 2>/dev/null | head -1)
C "[ -n \"$FILE\" ]" "manifest in staticPodPath"
C "grep -q 'nginx:1.27' \"$FILE\" 2>/dev/null" "image"
C "grep -q 'containerPort: 80' \"$FILE\" 2>/dev/null" "containerPort"
POD=$(kubectl get pods -A -o name 2>/dev/null | grep 'static-nginx' | head -1)
C "[ -n \"$POD\" ]" "mirror Pod visible"
C "kubectl get $POD -o jsonpath='{.metadata.annotations.kubernetes\\.io/config\\.source}' 2>/dev/null | grep -qx file" "static source=file"
C "kubectl get $POD -o jsonpath='{.status.phase}' 2>/dev/null | grep -qx Running" "Pod Running"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q13() {
echo "============================================================"
echo " Q13 VALIDATION"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. same Pod name exists"
echo "  2. image fixed"
echo "  3. Running"
echo "  4. Ready"
echo "  5. container ready"
echo "  6. name preserved"
echo
echo "[RESULT]"
NS=repair; PASS=0; TOTAL=6
C(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
C "kubectl -n $NS get pod web" "same Pod name exists"
C "[ \"$(kubectl -n $NS get pod web -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)\" = nginx:1.27 ]" "image fixed"
C "[ \"$(kubectl -n $NS get pod web -o jsonpath='{.status.phase}' 2>/dev/null)\" = Running ]" "Running"
C "kubectl -n $NS wait --for=condition=Ready pod/web --timeout=30s" "Ready"
C "[ \"$(kubectl -n $NS get pod web -o jsonpath='{.status.containerStatuses[0].ready}' 2>/dev/null)\" = true ]" "container ready"
C "[ \"$(kubectl -n $NS get pod web -o jsonpath='{.metadata.name}' 2>/dev/null)\" = web ]" "name preserved"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q14() {
echo "============================================================"
echo " Q14 VALIDATION"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. kubelet active"
echo "  2. Node exists"
echo "  3. Node Ready"
echo "  4. journal accessible"
echo "  5. kubelet enabled"
echo "  6. kubelet version reported"
echo "  7. no memory pressure"
echo "  8. no disk pressure"
echo
echo "[RESULT]"
STATE=/tmp/cka-q14-node
if [ ! -f "$STATE" ]; then echo "[SKIP] Q14 was not configured."; exit 0; fi
NODE=$(cat "$STATE")
PASS=0; TOTAL=8
C(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
C "ssh -o BatchMode=yes -o ConnectTimeout=3 \"$NODE\" 'systemctl is-active --quiet kubelet'" "kubelet active"
C "kubectl get node \"$NODE\"" "Node exists"
C "[ \"$(kubectl get node \"$NODE\" -o jsonpath='{.status.conditions[?(@.type==\"Ready\")].status}' 2>/dev/null)\" = True ]" "Node Ready"
C "ssh \"$NODE\" 'journalctl -u kubelet -n 1 --no-pager >/dev/null'" "journal accessible"
C "ssh \"$NODE\" 'systemctl is-enabled kubelet >/dev/null 2>&1'" "kubelet enabled"
C "kubectl get node \"$NODE\" -o jsonpath='{.status.nodeInfo.kubeletVersion}' | grep -q '^v'" "kubelet version reported"
C "kubectl get node \"$NODE\" -o jsonpath='{.status.conditions[?(@.type==\"MemoryPressure\")].status}' | grep -qx False" "no memory pressure"
C "kubectl get node \"$NODE\" -o jsonpath='{.status.conditions[?(@.type==\"DiskPressure\")].status}' | grep -qx False" "no disk pressure"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q15() {
echo "============================================================"
echo " Q15 VALIDATION"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. Deployment exists"
echo "  2. replicas intact"
echo "  3. image intact"
echo "  4. service port 8080"
echo "  5. targetPort corrected to 80"
echo "  6. selector intact"
echo "  7. Endpoints present"
echo "  8. EndpointSlice present"
echo "  9. service reachable"
echo "  10. 3 frontend Pods Running"
echo
echo "[RESULT]"
NS=final; PASS=0; TOTAL=10
C(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
C "kubectl -n $NS get deploy frontend" "Deployment exists"
C "[ \"$(kubectl -n $NS get deploy frontend -o jsonpath='{.spec.replicas}' 2>/dev/null)\" = 3 ]" "replicas intact"
C "[ \"$(kubectl -n $NS get deploy frontend -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)\" = nginx:1.27 ]" "image intact"
C "[ \"$(kubectl -n $NS get svc frontend-svc -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)\" = 8080 ]" "service port 8080"
C "[ \"$(kubectl -n $NS get svc frontend-svc -o jsonpath='{.spec.ports[0].targetPort}' 2>/dev/null)\" = 80 ]" "targetPort corrected to 80"
C "[ \"$(kubectl -n $NS get svc frontend-svc -o jsonpath='{.spec.selector.app}' 2>/dev/null)\" = frontend ]" "selector intact"
C "[ -n \"$(kubectl -n $NS get endpoints frontend-svc -o jsonpath='{.subsets[*].addresses[*].ip}' 2>/dev/null)\" ]" "Endpoints present"
C "kubectl -n $NS get endpointslice -l kubernetes.io/service-name=frontend-svc >/dev/null 2>&1" "EndpointSlice present"
C "kubectl -n $NS exec client -- wget -q -T 5 -O- http://frontend-svc:8080 >/dev/null" "service reachable"
C "[ \"$(kubectl -n $NS get pods -l app=frontend --field-selector=status.phase=Running --no-headers 2>/dev/null | wc -l)\" -eq 3 ]" "3 frontend Pods Running"
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
