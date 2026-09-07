#!/usr/bin/env bash
set -u
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

q1() {
echo "============================================================"
echo " CKA Practice Set #3 - Q1 SETUP"
echo "============================================================"
kubectl delete ns rollout3 --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo '[READY] Clean environment.'
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q1/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q1, then run: ./scripts/validate_question.sh 1"
echo "============================================================"
}

q2() {
echo "============================================================"
echo " CKA Practice Set #3 - Q2 SETUP"
echo "============================================================"
kubectl delete ns mixed-config --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns mixed-config
kubectl -n mixed-config create configmap app-config --from-literal=APP_MODE=production --from-literal=LOG_LEVEL=info
kubectl -n mixed-config create secret generic app-secret --from-literal=API_KEY=cka-key
echo '[READY] ConfigMap and Secret prepared.'
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q2/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q2, then run: ./scripts/validate_question.sh 2"
echo "============================================================"
}

q3() {
echo "============================================================"
echo " CKA Practice Set #3 - Q3 SETUP"
echo "============================================================"
kubectl delete ns schedule3 --ignore-not-found --wait=false >/dev/null 2>&1 || true
for n in $(kubectl get nodes -o name | cut -d/ -f2); do kubectl label node "$n" tier- >/dev/null 2>&1 || true; done
echo '[READY] Scheduling environment cleaned.'
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q3/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q3, then run: ./scripts/validate_question.sh 3"
echo "============================================================"
}

q4() {
echo "============================================================"
echo " CKA Practice Set #3 - Q4 SETUP"
echo "============================================================"
kubectl delete ns hpa3 --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns hpa3
kubectl -n hpa3 create deployment web --image=nginx:1.27
echo '[READY] Deployment web prepared without CPU request.'
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q4/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q4, then run: ./scripts/validate_question.sh 4"
echo "============================================================"
}

q5() {
echo "============================================================"
echo " CKA Practice Set #3 - Q5 SETUP"
echo "============================================================"
kubectl delete ns dev-a dev-b --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl delete clusterrole config-reader --ignore-not-found >/dev/null 2>&1 || true
kubectl create ns dev-a; kubectl create ns dev-b
kubectl -n dev-a create configmap sample --from-literal=x=1
kubectl -n dev-b create configmap sample --from-literal=x=2
echo '[READY] RBAC namespaces prepared.'
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q5/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q5, then run: ./scripts/validate_question.sh 5"
echo "============================================================"
}

q6() {
echo "============================================================"
echo " CKA Practice Set #3 - Q6 SETUP"
echo "============================================================"
kubectl delete ns svc3 --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns svc3
kubectl -n svc3 create deployment web --image=nginx:1.27 --replicas=2
kubectl -n svc3 expose deployment web --name=web-svc --port=8080 --target-port=8081
kubectl -n svc3 patch svc web-svc -p '{"spec":{"selector":{"app":"wrong"}}}' >/dev/null
kubectl -n svc3 run client --image=busybox:1.36 --command -- sleep 3600
kubectl -n svc3 wait --for=condition=Ready pod --all --timeout=60s >/dev/null 2>&1 || true
echo '[READY] Service has two faults.'
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q6/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q6, then run: ./scripts/validate_question.sh 6"
echo "============================================================"
}

q7() {
echo "============================================================"
echo " CKA Practice Set #3 - Q7 SETUP"
echo "============================================================"
kubectl delete ns net3 --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns net3
kubectl -n net3 run frontend --image=busybox:1.36 --labels=app=frontend --command -- sleep 3600
kubectl -n net3 run backend --image=nginx:1.27 --labels=app=backend
kubectl -n net3 run random --image=busybox:1.36 --labels=app=random --command -- sleep 3600
kubectl -n net3 wait --for=condition=Ready pod --all --timeout=60s >/dev/null 2>&1 || true
echo '[READY] NetworkPolicy lab prepared.'
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q7/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q7, then run: ./scripts/validate_question.sh 7"
echo "============================================================"
}

q8() {
echo "============================================================"
echo " CKA Practice Set #3 - Q8 SETUP"
echo "============================================================"
kubectl delete ns client-a client-b db3 --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns client-a; kubectl create ns client-b; kubectl create ns db3
kubectl -n client-a run app --image=busybox:1.36 --labels=role=client --command -- sleep 3600
kubectl -n client-b run app --image=busybox:1.36 --labels=role=client --command -- sleep 3600
kubectl -n db3 run database --image=nginx:1.27 --labels=role=db
kubectl wait -n client-a --for=condition=Ready pod/app --timeout=60s >/dev/null 2>&1 || true
kubectl wait -n client-b --for=condition=Ready pod/app --timeout=60s >/dev/null 2>&1 || true
kubectl wait -n db3 --for=condition=Ready pod/database --timeout=60s >/dev/null 2>&1 || true
echo '[READY] Cross-namespace lab prepared.'
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q8/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q8, then run: ./scripts/validate_question.sh 8"
echo "============================================================"
}

q9() {
echo "============================================================"
echo " CKA Practice Set #3 - Q9 SETUP"
echo "============================================================"
kubectl delete ns storage3 --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl delete pv pv3 --ignore-not-found >/dev/null 2>&1 || true
kubectl delete sc manual3 --ignore-not-found >/dev/null 2>&1 || true
cat <<'EOF' | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: manual3
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: Immediate
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv3
spec:
  capacity:
    storage: 3Gi
  accessModes: [ReadWriteOnce]
  storageClassName: manual3
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /tmp/pv3
EOF
echo '[READY] manual3 and pv3 prepared.'
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q9/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q9, then run: ./scripts/validate_question.sh 9"
echo "============================================================"
}

q10() {
echo "============================================================"
echo " CKA Practice Set #3 - Q10 SETUP"
echo "============================================================"
kubectl delete ns kustom3 --ignore-not-found --wait=false >/dev/null 2>&1 || true
rm -f "$ROOT_DIR/q10/overlay/kustomization.yaml" "$ROOT_DIR/q10/overlay/patch.yaml"
echo '[READY] q10/base prepared.'
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q10/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q10, then run: ./scripts/validate_question.sh 10"
echo "============================================================"
}

q11() {
echo "============================================================"
echo " CKA Practice Set #3 - Q11 SETUP"
echo "============================================================"
kubectl delete ns crd3 --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl delete crd backups.example.com --ignore-not-found >/dev/null 2>&1 || true
kubectl create ns crd3
cat <<'EOF' | kubectl apply -f -
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: backups.example.com
spec:
  group: example.com
  scope: Namespaced
  names:
    plural: backups
    singular: backup
    kind: Backup
  versions:
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            properties:
              schedule: {type: string}
              retention: {type: integer}
EOF
echo '[READY] Backup CRD prepared.'
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q11/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q11, then run: ./scripts/validate_question.sh 11"
echo "============================================================"
}

q12() {
echo "============================================================"
echo " CKA Practice Set #3 - Q12 SETUP"
echo "============================================================"
kubectl delete ns gateway3 --ignore-not-found --wait=false >/dev/null 2>&1 || true
if ! kubectl api-resources | grep -q httproutes; then echo '[SKIP] Gateway API CRDs not installed.'; return 0; fi
GC=$(kubectl get gatewayclass -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)
if [ -z "$GC" ]; then echo '[SKIP] No GatewayClass available.'; return 0; fi
kubectl create ns gateway3
kubectl -n gateway3 create deployment web --image=nginx:1.27
kubectl -n gateway3 expose deployment web --port=80 --target-port=80
cat <<EOF | kubectl apply -f -
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: shared-gateway
  namespace: gateway3
spec:
  gatewayClassName: $GC
  listeners:
  - name: http
    protocol: HTTP
    port: 80
EOF
echo '[READY] Gateway prepared.'
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q12/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q12, then run: ./scripts/validate_question.sh 12"
echo "============================================================"
}

q13() {
echo "============================================================"
echo " CKA Practice Set #3 - Q13 SETUP"
echo "============================================================"
kubectl delete ns repair3 --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns repair3
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: worker
  namespace: repair3
spec:
  containers:
  - name: worker
    image: busybox:1.36
    command: ["sh","-c","echo ready > /tmp/ready; exits 1"]
EOF
echo '[READY] Broken command prepared.'
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q13/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q13, then run: ./scripts/validate_question.sh 13"
echo "============================================================"
}

q14() {
echo "============================================================"
echo " CKA Practice Set #3 - Q14 SETUP"
echo "============================================================"
DIR=$(awk '/staticPodPath:/ {print $2}' /var/lib/kubelet/config.yaml 2>/dev/null || true)
[ -z "$DIR" ] && DIR=/etc/kubernetes/manifests
for f in $(grep -rl 'name: audit-web' "$DIR" 2>/dev/null || true); do rm -f "$f"; done
echo '[READY] Existing audit-web removed.'
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q14/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q14, then run: ./scripts/validate_question.sh 14"
echo "============================================================"
}

q15() {
echo "============================================================"
echo " CKA Practice Set #3 - Q15 SETUP"
echo "============================================================"
kubectl delete ns final3 --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns final3
kubectl -n final3 create deployment api --image=nginx:1.27 --replicas=2
kubectl -n final3 expose deployment api --name=api-svc --port=8080 --target-port=8081
kubectl -n final3 run client --image=busybox:1.36 --labels=app=client --command -- sleep 3600
cat <<'EOF' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: api-ingress
  namespace: final3
spec:
  podSelector:
    matchLabels:
      app: api
  policyTypes: [Ingress]
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: wrong-client
    ports:
    - protocol: TCP
      port: 80
EOF
kubectl -n final3 wait --for=condition=Ready pod --all --timeout=60s >/dev/null 2>&1 || true
echo '[READY] Two faults prepared.'
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q15/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q15, then run: ./scripts/validate_question.sh 15"
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