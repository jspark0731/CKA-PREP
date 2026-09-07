#!/usr/bin/env bash
set -u
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

q1() {
echo "============================================================"
echo " CKA Practice Set #3 - Q1 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. Deployment exists"
echo "  2. replicas=4"
echo "  3. rolling strategy 1/1"
echo "  4. image nginx:1.28"
echo "  5. rollout complete"
echo "  6. 4 Pods Ready"
echo
echo "[RESULT]"
PASS=0; TOTAL=6
check(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
check 'kubectl -n rollout3 get deploy api' "Deployment exists"
check '[ "$(kubectl -n rollout3 get deploy api -o jsonpath='\''{.spec.replicas}'\'')" = 4 ]' "replicas=4"
check '[ "$(kubectl -n rollout3 get deploy api -o jsonpath='\''{.spec.strategy.rollingUpdate.maxUnavailable}'\'')" = 1 ] && [ "$(kubectl -n rollout3 get deploy api -o jsonpath='\''{.spec.strategy.rollingUpdate.maxSurge}'\'')" = 1 ]' "rolling strategy 1/1"
check '[ "$(kubectl -n rollout3 get deploy api -o jsonpath='\''{.spec.template.spec.containers[0].image}'\'')" = nginx:1.28 ]' "image nginx:1.28"
check 'kubectl -n rollout3 rollout status deploy/api --timeout=40s' "rollout complete"
check '[ "$(kubectl -n rollout3 get pods -l app=api -o jsonpath='\''{range .items[*]}{.status.containerStatuses[0].ready}{"\n"}{end}'\'' | grep -c true)" -eq 4 ]' "4 Pods Ready"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q2() {
echo "============================================================"
echo " CKA Practice Set #3 - Q2 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. Pod exists"
echo "  2. Pod Ready"
echo "  3. ConfigMap envFrom"
echo "  4. Secret keyRef"
echo "  5. ConfigMap values"
echo "  6. API_KEY value"
echo
echo "[RESULT]"
PASS=0; TOTAL=6
check(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
check 'kubectl -n mixed-config get pod mixed-reader' "Pod exists"
check 'kubectl -n mixed-config wait --for=condition=Ready pod/mixed-reader --timeout=30s' "Pod Ready"
check 'kubectl -n mixed-config get pod mixed-reader -o jsonpath='\''{.spec.containers[0].envFrom[*].configMapRef.name}'\'' | grep -qw app-config' "ConfigMap envFrom"
check 'kubectl -n mixed-config get pod mixed-reader -o yaml | grep -A8 '\''name: API_KEY'\'' | grep -q '\''name: app-secret'\''' "Secret keyRef"
check '[ "$(kubectl -n mixed-config exec mixed-reader -- sh -c '\''printf %s:$LOG_LEVEL "$APP_MODE"'\'' 2>/dev/null)" = production:info ]' "ConfigMap values"
check '[ "$(kubectl -n mixed-config exec mixed-reader -- sh -c '\''printf %s "$API_KEY"'\'' 2>/dev/null)" = cka-key ]' "API_KEY value"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q3() {
echo "============================================================"
echo " CKA Practice Set #3 - Q3 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. tier=compute node"
echo "  2. Deployment exists"
echo "  3. replicas=2"
echo "  4. requests"
echo "  5. limits"
echo "  6. Pods on compute node"
echo
echo "[RESULT]"
PASS=0; TOTAL=6
check(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
check '[ -n "$(kubectl get nodes -l tier=compute -o jsonpath='\''{.items[0].metadata.name}'\'' 2>/dev/null)" ]' "tier=compute node"
check 'kubectl -n schedule3 get deploy worker' "Deployment exists"
check '[ "$(kubectl -n schedule3 get deploy worker -o jsonpath='\''{.spec.replicas}'\'')" = 2 ]' "replicas=2"
check '[ "$(kubectl -n schedule3 get deploy worker -o jsonpath='\''{.spec.template.spec.containers[0].resources.requests.cpu}'\'')" = 100m ] && [ "$(kubectl -n schedule3 get deploy worker -o jsonpath='\''{.spec.template.spec.containers[0].resources.requests.memory}'\'')" = 64Mi ]' "requests"
check '[ "$(kubectl -n schedule3 get deploy worker -o jsonpath='\''{.spec.template.spec.containers[0].resources.limits.cpu}'\'')" = 300m ] && [ "$(kubectl -n schedule3 get deploy worker -o jsonpath='\''{.spec.template.spec.containers[0].resources.limits.memory}'\'')" = 128Mi ]' "limits"
check 'NODE=$(kubectl get nodes -l tier=compute -o jsonpath='\''{.items[0].metadata.name}'\''); [ "$(kubectl -n schedule3 get pods -l app=worker -o jsonpath='\''{range .items[*]}{.spec.nodeName}{"\n"}{end}'\'' | sort -u)" = "$NODE" ]' "Pods on compute node"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q4() {
echo "============================================================"
echo " CKA Practice Set #3 - Q4 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. HPA exists"
echo "  2. min=2"
echo "  3. max=5"
echo "  4. CPU target 60%"
echo "  5. CPU request exists"
echo "  6. target web"
echo
echo "[RESULT]"
PASS=0; TOTAL=6
check(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
check 'kubectl -n hpa3 get hpa web-hpa' "HPA exists"
check '[ "$(kubectl -n hpa3 get hpa web-hpa -o jsonpath='\''{.spec.minReplicas}'\'')" = 2 ]' "min=2"
check '[ "$(kubectl -n hpa3 get hpa web-hpa -o jsonpath='\''{.spec.maxReplicas}'\'')" = 5 ]' "max=5"
check 'kubectl -n hpa3 get hpa web-hpa -o jsonpath='\''{.spec.metrics[0].resource.target.averageUtilization}'\'' | grep -qx 60' "CPU target 60%"
check '[ -n "$(kubectl -n hpa3 get deploy web -o jsonpath='\''{.spec.template.spec.containers[0].resources.requests.cpu}'\'')" ]' "CPU request exists"
check '[ "$(kubectl -n hpa3 get hpa web-hpa -o jsonpath='\''{.spec.scaleTargetRef.name}'\'')" = web ]' "target web"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q5() {
echo "============================================================"
echo " CKA Practice Set #3 - Q5 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. dev-a SA"
echo "  2. dev-b SA"
echo "  3. ClusterRole"
echo "  4. dev-a RoleBinding"
echo "  5. dev-b RoleBinding"
echo "  6. own namespace allowed"
echo "  7. cross namespace denied"
echo
echo "[RESULT]"
PASS=0; TOTAL=7
check(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
check 'kubectl -n dev-a get sa dev-reader' "dev-a SA"
check 'kubectl -n dev-b get sa dev-reader' "dev-b SA"
check 'kubectl get clusterrole config-reader' "ClusterRole"
check 'kubectl -n dev-a get rolebinding config-reader' "dev-a RoleBinding"
check 'kubectl -n dev-b get rolebinding config-reader' "dev-b RoleBinding"
check 'kubectl auth can-i get configmaps -n dev-a --as=system:serviceaccount:dev-a:dev-reader | grep -qx yes && kubectl auth can-i get configmaps -n dev-b --as=system:serviceaccount:dev-b:dev-reader | grep -qx yes' "own namespace allowed"
check 'kubectl auth can-i get configmaps -n dev-b --as=system:serviceaccount:dev-a:dev-reader | grep -qx no' "cross namespace denied"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q6() {
echo "============================================================"
echo " CKA Practice Set #3 - Q6 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. selector matches Pods"
echo "  2. service port 8080"
echo "  3. targetPort 80"
echo "  4. EndpointSlice addresses"
echo "  5. service reachable"
echo "  6. replicas intact"
echo "  7. image intact"
echo
echo "[RESULT]"
PASS=0; TOTAL=7
check(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
check 'P=$(kubectl -n svc3 get deploy web -o jsonpath='\''{.spec.template.metadata.labels.app}'\''); [ "$(kubectl -n svc3 get svc web-svc -o jsonpath='\''{.spec.selector.app}'\'')" = "$P" ]' "selector matches Pods"
check '[ "$(kubectl -n svc3 get svc web-svc -o jsonpath='\''{.spec.ports[0].port}'\'')" = 8080 ]' "service port 8080"
check '[ "$(kubectl -n svc3 get svc web-svc -o jsonpath='\''{.spec.ports[0].targetPort}'\'')" = 80 ]' "targetPort 80"
check '[ -n "$(kubectl -n svc3 get endpointslice -l kubernetes.io/service-name=web-svc -o jsonpath='\''{.items[*].endpoints[*].addresses[*]}'\'' 2>/dev/null)" ]' "EndpointSlice addresses"
check 'kubectl -n svc3 exec client -- wget -q -T 5 -O- http://web-svc:8080 >/dev/null' "service reachable"
check '[ "$(kubectl -n svc3 get deploy web -o jsonpath='\''{.spec.replicas}'\'')" = 2 ]' "replicas intact"
check '[ "$(kubectl -n svc3 get deploy web -o jsonpath='\''{.spec.template.spec.containers[0].image}'\'')" = nginx:1.27 ]' "image intact"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q7() {
echo "============================================================"
echo " CKA Practice Set #3 - Q7 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. at least two policies"
echo "  2. frontend selected"
echo "  3. backend selected"
echo "  4. egress TCP/80"
echo "  5. egress UDP/53"
echo "  6. frontend→backend succeeds"
echo "  7. random blocked"
echo "  8. Ingress and Egress enforced"
echo
echo "[RESULT]"
PASS=0; TOTAL=8
check(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
check '[ "$(kubectl -n net3 get netpol --no-headers 2>/dev/null | wc -l)" -ge 2 ]' "at least two policies"
check 'kubectl -n net3 get netpol -o yaml | grep -q '\''app: frontend'\''' "frontend selected"
check 'kubectl -n net3 get netpol -o yaml | grep -q '\''app: backend'\''' "backend selected"
check 'kubectl -n net3 get netpol -o jsonpath='\''{range .items[*].spec.egress[*].ports[*]}{.protocol}{"/"}{.port}{"\n"}{end}'\'' | grep -qx TCP/80' "egress TCP/80"
check 'kubectl -n net3 get netpol -o jsonpath='\''{range .items[*].spec.egress[*].ports[*]}{.protocol}{"/"}{.port}{"\n"}{end}'\'' | grep -qx UDP/53' "egress UDP/53"
check 'B=$(kubectl -n net3 get pod backend -o jsonpath='\''{.status.podIP}'\''); kubectl -n net3 exec frontend -- wget -q -T 4 -O- http://$B >/dev/null' "frontend→backend succeeds"
check 'B=$(kubectl -n net3 get pod backend -o jsonpath='\''{.status.podIP}'\''); ! kubectl -n net3 exec random -- wget -q -T 3 -O- http://$B >/dev/null 2>&1' "random blocked"
check 'kubectl -n net3 get netpol -o jsonpath='\''{range .items[*].spec.policyTypes[*]}{.}{"\n"}{end}'\'' | grep -q Ingress && kubectl -n net3 get netpol -o jsonpath='\''{range .items[*].spec.policyTypes[*]}{.}{"\n"}{end}'\'' | grep -q Egress' "Ingress and Egress enforced"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q8() {
echo "============================================================"
echo " CKA Practice Set #3 - Q8 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. NetworkPolicy exists"
echo "  2. selects database"
echo "  3. namespaceSelector"
echo "  4. client-a selected"
echo "  5. role=client selected"
echo "  6. port 80"
echo "  7. client-a allowed"
echo "  8. client-b blocked"
echo
echo "[RESULT]"
PASS=0; TOTAL=8
check(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
check '[ "$(kubectl -n db3 get netpol --no-headers 2>/dev/null | wc -l)" -ge 1 ]' "NetworkPolicy exists"
check 'kubectl -n db3 get netpol -o jsonpath='\''{.items[0].spec.podSelector.matchLabels.role}'\'' | grep -qx db' "selects database"
check 'kubectl -n db3 get netpol -o yaml | grep -q namespaceSelector' "namespaceSelector"
check 'kubectl -n db3 get netpol -o yaml | grep -q client-a' "client-a selected"
check 'kubectl -n db3 get netpol -o jsonpath='\''{.items[0].spec.ingress[*].from[*].podSelector.matchLabels.role}'\'' | grep -qw client' "role=client selected"
check 'kubectl -n db3 get netpol -o jsonpath='\''{.items[0].spec.ingress[*].ports[*].port}'\'' | grep -qw 80' "port 80"
check 'D=$(kubectl -n db3 get pod database -o jsonpath='\''{.status.podIP}'\''); kubectl -n client-a exec app -- wget -q -T 4 -O- http://$D >/dev/null' "client-a allowed"
check 'D=$(kubectl -n db3 get pod database -o jsonpath='\''{.status.podIP}'\''); ! kubectl -n client-b exec app -- wget -q -T 3 -O- http://$D >/dev/null 2>&1' "client-b blocked"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q9() {
echo "============================================================"
echo " CKA Practice Set #3 - Q9 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. PVC exists"
echo "  2. StorageClass"
echo "  3. request 3Gi"
echo "  4. RWO"
echo "  5. mount /data"
echo "  6. Pod Ready"
echo "  7. file content"
echo
echo "[RESULT]"
PASS=0; TOTAL=7
check(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
check 'kubectl -n storage3 get pvc data' "PVC exists"
check '[ "$(kubectl -n storage3 get pvc data -o jsonpath='\''{.spec.storageClassName}'\'')" = manual3 ]' "StorageClass"
check '[ "$(kubectl -n storage3 get pvc data -o jsonpath='\''{.spec.resources.requests.storage}'\'')" = 3Gi ]' "request 3Gi"
check 'kubectl -n storage3 get pvc data -o jsonpath='\''{.spec.accessModes[*]}'\'' | grep -qw ReadWriteOnce' "RWO"
check 'kubectl -n storage3 get pod writer -o jsonpath='\''{range .spec.containers[0].volumeMounts[*]}{.mountPath}{"\n"}{end}'\'' | grep -qx /data' "mount /data"
check 'kubectl -n storage3 wait --for=condition=Ready pod/writer --timeout=30s' "Pod Ready"
check '[ "$(kubectl -n storage3 exec writer -- cat /data/result.txt 2>/dev/null)" = set3-storage ]' "file content"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q10() {
echo "============================================================"
echo " CKA Practice Set #3 - Q10 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. kustomize builds"
echo "  2. namespace kustom3"
echo "  3. namePrefix stage-"
echo "  4. replicas 2"
echo "  5. image nginx:1.28"
echo "  6. env=stage label"
echo "  7. deploy and Service work"
echo
echo "[RESULT]"
PASS=0; TOTAL=7
check(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
check 'kubectl kustomize "$ROOT_DIR/q10/overlay" >/dev/null' "kustomize builds"
check 'kubectl kustomize "$ROOT_DIR/q10/overlay" | grep -q '\''namespace: kustom3'\''' "namespace kustom3"
check 'kubectl kustomize "$ROOT_DIR/q10/overlay" | grep -q '\''name: stage-web'\''' "namePrefix stage-"
check 'kubectl kustomize "$ROOT_DIR/q10/overlay" | grep -q '\''replicas: 2'\''' "replicas 2"
check 'kubectl kustomize "$ROOT_DIR/q10/overlay" | grep -q '\''image: nginx:1.28'\''' "image nginx:1.28"
check 'kubectl kustomize "$ROOT_DIR/q10/overlay" | grep -q '\''env: stage'\''' "env=stage label"
check 'kubectl apply -k "$ROOT_DIR/q10/overlay" >/dev/null && kubectl -n kustom3 rollout status deploy/stage-web --timeout=40s >/dev/null && [ -n "$(kubectl -n kustom3 get endpointslice -l kubernetes.io/service-name=stage-web -o jsonpath='\''{.items[*].endpoints[*].addresses[*]}'\'' 2>/dev/null)" ]' "deploy and Service work"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q11() {
echo "============================================================"
echo " CKA Practice Set #3 - Q11 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. CRD exists"
echo "  2. Custom Resource exists"
echo "  3. apiVersion"
echo "  4. kind Backup"
echo "  5. schedule"
echo "  6. retention"
echo "  7. namespace"
echo
echo "[RESULT]"
PASS=0; TOTAL=7
check(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
check 'kubectl get crd backups.example.com' "CRD exists"
check 'kubectl -n crd3 get backup daily-backup' "Custom Resource exists"
check '[ "$(kubectl -n crd3 get backup daily-backup -o jsonpath='\''{.apiVersion}'\'')" = example.com/v1 ]' "apiVersion"
check '[ "$(kubectl -n crd3 get backup daily-backup -o jsonpath='\''{.kind}'\'')" = Backup ]' "kind Backup"
check '[ "$(kubectl -n crd3 get backup daily-backup -o jsonpath='\''{.spec.schedule}'\'')" = '\''0 2 * * *'\'' ]' "schedule"
check '[ "$(kubectl -n crd3 get backup daily-backup -o jsonpath='\''{.spec.retention}'\'')" = 7 ]' "retention"
check '[ "$(kubectl -n crd3 get backup daily-backup -o jsonpath='\''{.metadata.namespace}'\'')" = crd3 ]' "namespace"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q12() {
echo "============================================================"
echo " CKA Practice Set #3 - Q12 VALIDATE"
echo "============================================================"
if ! kubectl api-resources | grep -q httproutes; then echo '[SKIP] Gateway API unavailable'; return 0; fi
echo "[SCORING ITEMS]"
echo "  1. HTTPRoute exists"
echo "  2. parent Gateway"
echo "  3. hostname"
echo "  4. PathPrefix"
echo "  5. path /app"
echo "  6. backend web:80"
echo
echo "[RESULT]"
PASS=0; TOTAL=6
check(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
check 'kubectl -n gateway3 get httproute web-route' "HTTPRoute exists"
check 'kubectl -n gateway3 get httproute web-route -o jsonpath='\''{.spec.parentRefs[*].name}'\'' | grep -qw shared-gateway' "parent Gateway"
check 'kubectl -n gateway3 get httproute web-route -o jsonpath='\''{.spec.hostnames[*]}'\'' | grep -qw web.cka.local' "hostname"
check 'kubectl -n gateway3 get httproute web-route -o yaml | grep -q PathPrefix' "PathPrefix"
check 'kubectl -n gateway3 get httproute web-route -o yaml | grep -q '\''/app'\''' "path /app"
check '[ "$(kubectl -n gateway3 get httproute web-route -o jsonpath='\''{.spec.rules[0].backendRefs[0].name}'\'')" = web ] && [ "$(kubectl -n gateway3 get httproute web-route -o jsonpath='\''{.spec.rules[0].backendRefs[0].port}'\'')" = 80 ]' "backend web:80"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q13() {
echo "============================================================"
echo " CKA Practice Set #3 - Q13 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. Pod exists"
echo "  2. image intact"
echo "  3. Pod Ready"
echo "  4. /tmp/ready exists"
echo "  5. file content ready"
echo "  6. Running"
echo
echo "[RESULT]"
PASS=0; TOTAL=6
check(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
check 'kubectl -n repair3 get pod worker' "Pod exists"
check '[ "$(kubectl -n repair3 get pod worker -o jsonpath='\''{.spec.containers[0].image}'\'')" = busybox:1.36 ]' "image intact"
check 'kubectl -n repair3 wait --for=condition=Ready pod/worker --timeout=30s' "Pod Ready"
check 'kubectl -n repair3 exec worker -- test -f /tmp/ready' "/tmp/ready exists"
check '[ "$(kubectl -n repair3 exec worker -- cat /tmp/ready 2>/dev/null)" = ready ]' "file content ready"
check '[ "$(kubectl -n repair3 get pod worker -o jsonpath='\''{.status.phase}'\'')" = Running ]' "Running"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q14() {
echo "============================================================"
echo " CKA Practice Set #3 - Q14 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. manifest in staticPodPath"
echo "  2. image"
echo "  3. containerPort"
echo "  4. mirror Pod visible"
echo "  5. source=file"
echo "  6. Running"
echo
echo "[RESULT]"
PASS=0; TOTAL=6
check(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
check 'DIR=$(awk '\''/staticPodPath:/ {print $2}'\'' /var/lib/kubelet/config.yaml 2>/dev/null || true); [ -z "$DIR" ] && DIR=/etc/kubernetes/manifests; grep -rl '\''name: audit-web'\'' "$DIR" | grep -q .' "manifest in staticPodPath"
check 'DIR=$(awk '\''/staticPodPath:/ {print $2}'\'' /var/lib/kubelet/config.yaml 2>/dev/null || true); [ -z "$DIR" ] && DIR=/etc/kubernetes/manifests; grep -rl '\''name: audit-web'\'' "$DIR" | xargs grep -q '\''nginx:1.27'\''' "image"
check 'DIR=$(awk '\''/staticPodPath:/ {print $2}'\'' /var/lib/kubelet/config.yaml 2>/dev/null || true); [ -z "$DIR" ] && DIR=/etc/kubernetes/manifests; grep -rl '\''name: audit-web'\'' "$DIR" | xargs grep -q '\''containerPort: 80'\''' "containerPort"
check 'kubectl get pods -A -o name | grep -q audit-web' "mirror Pod visible"
check 'P=$(kubectl get pods -A -o name | grep audit-web | head -1); kubectl get $P -o jsonpath='\''{.metadata.annotations.kubernetes\.io/config\.source}'\'' | grep -qx file' "source=file"
check 'P=$(kubectl get pods -A -o name | grep audit-web | head -1); kubectl get $P -o jsonpath='\''{.status.phase}'\'' | grep -qx Running' "Running"
echo "Score: $PASS / $TOTAL"
echo "============================================================"
}

q15() {
echo "============================================================"
echo " CKA Practice Set #3 - Q15 VALIDATE"
echo "============================================================"
echo "[SCORING ITEMS]"
echo "  1. Deployment exists"
echo "  2. replicas intact"
echo "  3. image intact"
echo "  4. service port 8080"
echo "  5. targetPort fixed"
echo "  6. EndpointSlice addresses"
echo "  7. NetworkPolicy exists"
echo "  8. client allowed"
echo "  9. policy port 80"
echo "  10. client access succeeds"
echo
echo "[RESULT]"
PASS=0; TOTAL=10
check(){ if eval "$1" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "[PASS] $2"; else echo "[FAIL] $2"; fi; }
check 'kubectl -n final3 get deploy api' "Deployment exists"
check '[ "$(kubectl -n final3 get deploy api -o jsonpath='\''{.spec.replicas}'\'')" = 2 ]' "replicas intact"
check '[ "$(kubectl -n final3 get deploy api -o jsonpath='\''{.spec.template.spec.containers[0].image}'\'')" = nginx:1.27 ]' "image intact"
check '[ "$(kubectl -n final3 get svc api-svc -o jsonpath='\''{.spec.ports[0].port}'\'')" = 8080 ]' "service port 8080"
check '[ "$(kubectl -n final3 get svc api-svc -o jsonpath='\''{.spec.ports[0].targetPort}'\'')" = 80 ]' "targetPort fixed"
check '[ -n "$(kubectl -n final3 get endpointslice -l kubernetes.io/service-name=api-svc -o jsonpath='\''{.items[*].endpoints[*].addresses[*]}'\'' 2>/dev/null)" ]' "EndpointSlice addresses"
check 'kubectl -n final3 get netpol api-ingress' "NetworkPolicy exists"
check 'kubectl -n final3 get netpol api-ingress -o jsonpath='\''{.spec.ingress[*].from[*].podSelector.matchLabels.app}'\'' | grep -qw client' "client allowed"
check 'kubectl -n final3 get netpol api-ingress -o jsonpath='\''{.spec.ingress[*].ports[*].port}'\'' | grep -qw 80' "policy port 80"
check 'kubectl -n final3 exec client -- wget -q -T 5 -O- http://api-svc:8080 >/dev/null' "client access succeeds"
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