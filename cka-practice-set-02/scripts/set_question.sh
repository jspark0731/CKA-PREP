#!/usr/bin/env bash
set -u
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

q1() {
echo "============================================================"
echo " CKA Practice Set #2 - Q1 SET"
echo "============================================================"
kubectl delete ns rollout-lab --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns rollout-lab
kubectl -n rollout-lab create deployment web --image=nginx:1.26 --replicas=3
kubectl -n rollout-lab rollout status deploy/web --timeout=60s >/dev/null 2>&1 || true
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
echo " CKA Practice Set #2 - Q2 SET"
echo "============================================================"
kubectl delete ns config-volume --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns config-volume
kubectl -n config-volume create configmap web-config --from-literal=index.html=hello-from-configmap
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
echo " CKA Practice Set #2 - Q3 SET"
echo "============================================================"
kubectl delete ns secret-lab --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns secret-lab
kubectl -n secret-lab create secret generic db-secret --from-literal=DB_USER=admin --from-literal=DB_PASSWORD=cka-secret
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
echo " CKA Practice Set #2 - Q4 SET"
echo "============================================================"
kubectl delete ns autoscale --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns autoscale
kubectl -n autoscale create deployment web --image=nginx:1.27
kubectl -n autoscale set resources deployment web --requests=cpu=100m,memory=64Mi --limits=cpu=200m,memory=128Mi >/dev/null 2>&1 || true
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
echo " CKA Practice Set #2 - Q5 SET"
echo "============================================================"
kubectl delete pod batch-job --ignore-not-found >/dev/null 2>&1 || true
for n in $(kubectl get nodes -o name | cut -d/ -f2); do kubectl taint node "$n" dedicated=batch:NoSchedule- >/dev/null 2>&1 || true; kubectl label node "$n" set2-batch- >/dev/null 2>&1 || true; done
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
echo " CKA Practice Set #2 - Q6 SET"
echo "============================================================"
kubectl delete ns dns-lab --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns dns-lab
kubectl -n dns-lab create deployment backend --image=nginx:1.27 --replicas=2
kubectl -n dns-lab expose deployment backend --name=backend-svc --port=8080 --target-port=8081
kubectl -n dns-lab run client --image=busybox:1.36 --command -- sleep 3600
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
echo " CKA Practice Set #2 - Q7 SET"
echo "============================================================"
kubectl delete ns egress-lab --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns egress-lab
kubectl -n egress-lab run client --image=busybox:1.36 --labels=app=client --command -- sleep 3600
kubectl -n egress-lab run web --image=nginx:1.27 --labels=app=web
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
echo " CKA Practice Set #2 - Q8 SET"
echo "============================================================"
kubectl delete ns team-a team-b database --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns team-a; kubectl create ns team-b; kubectl create ns database
kubectl -n team-a run client-a --image=busybox:1.36 --labels=access=db --command -- sleep 3600
kubectl -n team-b run client-b --image=busybox:1.36 --labels=access=db --command -- sleep 3600
kubectl -n database run db --image=nginx:1.27 --labels=app=db
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
echo " CKA Practice Set #2 - Q9 SET"
echo "============================================================"
kubectl delete ns qa --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl delete clusterrole pod-log-reader --ignore-not-found >/dev/null 2>&1 || true
kubectl create ns qa
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
echo " CKA Practice Set #2 - Q10 SET"
echo "============================================================"
kubectl delete ns pv-lab --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl delete pv set2-pv --ignore-not-found >/dev/null 2>&1 || true
kubectl delete sc set2-manual --ignore-not-found >/dev/null 2>&1 || true
cat <<'EOF' | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: set2-manual
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: Immediate
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: set2-pv
spec:
  capacity:
    storage: 2Gi
  accessModes: [ReadWriteOnce]
  storageClassName: set2-manual
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /tmp/set2-pv
EOF
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
echo " CKA Practice Set #2 - Q11 SET"
echo "============================================================"
kubectl delete ns kustomize-lab --ignore-not-found --wait=false >/dev/null 2>&1 || true
rm -f "$ROOT_DIR/q11/overlay/kustomization.yaml"
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
echo " CKA Practice Set #2 - Q12 SET"
echo "============================================================"
kubectl delete ns ingress2 --ignore-not-found --wait=false >/dev/null 2>&1 || true
CLS=$(kubectl get ingressclass -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)
if [ -z "$CLS" ]; then echo "[SKIP] No IngressClass available."; return 0; fi
kubectl create ns ingress2
kubectl -n ingress2 create deployment shop --image=nginx:1.27 --replicas=2
kubectl -n ingress2 expose deployment shop --port=80 --target-port=80
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
echo " CKA Practice Set #2 - Q13 SET"
echo "============================================================"
kubectl delete ns repair2 --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns repair2
kubectl -n repair2 create configmap app-config --from-literal=APP_MODE=production
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: app
  namespace: repair2
spec:
  containers:
  - name: app
    image: busybox:1.36
    command: ["sleep","3600"]
    env:
    - name: APP_MODE
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: WRONG_KEY
EOF
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
echo " CKA Practice Set #2 - Q14 SET"
echo "============================================================"
kubectl delete ns schedule-repair --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns schedule-repair
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: worker-app
  namespace: schedule-repair
spec:
  replicas: 2
  selector:
    matchLabels:
      app: worker-app
  template:
    metadata:
      labels:
        app: worker-app
    spec:
      nodeSelector:
        impossible-label: does-not-exist
      containers:
      - name: nginx
        image: nginx:1.27
EOF
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
echo " CKA Practice Set #2 - Q15 SET"
echo "============================================================"
kubectl delete ns final2 --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns final2
kubectl -n final2 create deployment api --image=nginx:1.27 --replicas=2
kubectl -n final2 expose deployment api --name=api-svc --port=8080 --target-port=80
kubectl -n final2 run client --image=busybox:1.36 --labels=app=client --command -- sleep 3600
cat <<'EOF' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: api-ingress
  namespace: final2
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
