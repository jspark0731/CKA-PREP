#!/usr/bin/env bash
set -u
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

q1() {
echo "============================================================"
echo " CKA Practice Set #1 - Q1"
echo "============================================================"
kubectl delete ns omega --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "[READY] Q1 environment initialized."
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q1/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q1, then run:"
echo "        ./scripts/validate_question.sh 1"
}

q2() {
echo "============================================================"
echo " CKA Practice Set #1 - Q2"
echo "============================================================"
kubectl delete ns app-config --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "[READY] Q2 environment initialized."
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q2/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q2, then run:"
echo "        ./scripts/validate_question.sh 2"
}

q3() {
echo "============================================================"
echo " CKA Practice Set #1 - Q3"
echo "============================================================"
kubectl delete ns storage-lab --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl delete pv q3-pv --ignore-not-found >/dev/null 2>&1 || true
kubectl delete sc cka-manual --ignore-not-found >/dev/null 2>&1 || true
cat <<'EOF' | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: cka-manual
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: Immediate
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: q3-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: cka-manual
  hostPath:
    path: /tmp/q3-data
EOF
echo "[READY] Q3 PV/StorageClass prepared."
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q3/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q3, then run:"
echo "        ./scripts/validate_question.sh 3"
}

q4() {
echo "============================================================"
echo " CKA Practice Set #1 - Q4"
echo "============================================================"
kubectl delete pod special-app --ignore-not-found >/dev/null 2>&1 || true
for n in $(kubectl get nodes -o name | cut -d/ -f2); do
  kubectl taint node "$n" workload=special:NoSchedule- >/dev/null 2>&1 || true
  kubectl label node "$n" workload- >/dev/null 2>&1 || true
done
echo "[READY] Q4 environment cleaned."
kubectl get nodes
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q4/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q4, then run:"
echo "        ./scripts/validate_question.sh 4"
}

q5() {
echo "============================================================"
echo " CKA Practice Set #1 - Q5"
echo "============================================================"
kubectl delete ns scheduling --ignore-not-found --wait=false >/dev/null 2>&1 || true
for n in $(kubectl get nodes -o name | cut -d/ -f2); do kubectl label node "$n" storage- >/dev/null 2>&1 || true; done
echo "[READY] Q5 environment cleaned."
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q5/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q5, then run:"
echo "        ./scripts/validate_question.sh 5"
}

q6() {
echo "============================================================"
echo " CKA Practice Set #1 - Q6"
echo "============================================================"
kubectl delete ns network-a --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns network-a
for p in frontend backend random; do
  kubectl -n network-a run "$p" --image=nginx:1.27 --labels="app=$p"
done
kubectl -n network-a wait --for=condition=Ready pod --all --timeout=60s || true
echo "[READY] Pods created. Create only the NetworkPolicy."
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q6/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q6, then run:"
echo "        ./scripts/validate_question.sh 6"
}

q7() {
echo "============================================================"
echo " CKA Practice Set #1 - Q7"
echo "============================================================"
kubectl delete ns network-a --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns network-a
for p in frontend backend random; do kubectl -n network-a run "$p" --image=nginx:1.27 --labels="app=$p"; done
cat <<'EOF' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all-ingress
  namespace: network-a
spec:
  podSelector: {}
  policyTypes:
  - Ingress
EOF
kubectl -n network-a wait --for=condition=Ready pod --all --timeout=60s || true
echo "[READY] Q7 baseline created."
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q7/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q7, then run:"
echo "        ./scripts/validate_question.sh 7"
}

q8() {
echo "============================================================"
echo " CKA Practice Set #1 - Q8"
echo "============================================================"
kubectl delete ns frontend-ns database-ns other-ns --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns frontend-ns
kubectl create ns database-ns
kubectl create ns other-ns
kubectl -n frontend-ns run client --image=busybox:1.36 --labels=role=frontend --command -- sleep 3600
kubectl -n database-ns run database --image=nginx:1.27 --labels=role=database
kubectl -n other-ns run outsider --image=busybox:1.36 --labels=role=frontend --command -- sleep 3600
kubectl wait -n frontend-ns --for=condition=Ready pod/client --timeout=60s || true
kubectl wait -n database-ns --for=condition=Ready pod/database --timeout=60s || true
kubectl wait -n other-ns --for=condition=Ready pod/outsider --timeout=60s || true
echo "[READY] Q8 pods created."
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q8/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q8, then run:"
echo "        ./scripts/validate_question.sh 8"
}

q9() {
echo "============================================================"
echo " CKA Practice Set #1 - Q9"
echo "============================================================"
kubectl delete ns svc-test --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns svc-test
kubectl -n svc-test create deploy api-server --image=nginx:1.27 --replicas=2
kubectl -n svc-test label deploy api-server app=api --overwrite
kubectl -n svc-test patch deploy api-server -p '{"spec":{"selector":{"matchLabels":{"app":"api"}},"template":{"metadata":{"labels":{"app":"api"}}}}}' >/dev/null
kubectl -n svc-test create service clusterip api-service --tcp=8080:80
kubectl -n svc-test patch svc api-service -p '{"spec":{"selector":{"app":"backend"}}}'
kubectl -n svc-test run client --image=busybox:1.36 --command -- sleep 3600
kubectl -n svc-test wait --for=condition=Ready pod --all --timeout=60s || true
echo "[READY] Q9 broken Service created."
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q9/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q9, then run:"
echo "        ./scripts/validate_question.sh 9"
}

q10() {
echo "============================================================"
echo " CKA Practice Set #1 - Q10"
echo "============================================================"
kubectl delete ns ingress-lab --ignore-not-found --wait=false >/dev/null 2>&1 || true
CLS=$(kubectl get ingressclass -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)
if [ -z "$CLS" ]; then
  echo "[SKIP] No IngressClass available in this Killercoda environment."
  exit 0
fi
kubectl create ns ingress-lab
kubectl -n ingress-lab create deploy web --image=nginx:1.27 --replicas=2
kubectl -n ingress-lab expose deploy web --port=80 --target-port=80
echo "[READY] ingressClass=$CLS"
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q10/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q10, then run:"
echo "        ./scripts/validate_question.sh 10"
}

q11() {
echo "============================================================"
echo " CKA Practice Set #1 - Q11"
echo "============================================================"
kubectl delete ns development --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns development
echo "[READY] Q11 namespace prepared."
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q11/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q11, then run:"
echo "        ./scripts/validate_question.sh 11"
}

q12() {
echo "============================================================"
echo " CKA Practice Set #1 - Q12"
echo "============================================================"
DIR=$(awk '/staticPodPath:/ {print $2}' /var/lib/kubelet/config.yaml 2>/dev/null || true)
[ -z "$DIR" ] && DIR=/etc/kubernetes/manifests
rm -f "$DIR/q12-static-nginx.yaml" "$DIR/static-nginx.yaml" 2>/dev/null || true
kubectl delete pod static-nginx-"$(hostname)" --ignore-not-found >/dev/null 2>&1 || true
echo "[READY] Q12 environment cleaned. Determine staticPodPath yourself."
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q12/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q12, then run:"
echo "        ./scripts/validate_question.sh 12"
}

q13() {
echo "============================================================"
echo " CKA Practice Set #1 - Q13"
echo "============================================================"
kubectl delete ns repair --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns repair
kubectl -n repair run web --image=nginx:does-not-exist-cka
echo "[READY] Q13 broken Pod created."
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q13/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q13, then run:"
echo "        ./scripts/validate_question.sh 13"
}

q14() {
echo "============================================================"
echo " CKA Practice Set #1 - Q14"
echo "============================================================"
STATE=/tmp/cka-q14-node
rm -f "$STATE"
CP=$(hostname)
WORKER=$(kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | grep -v "^$CP$" | head -1)
if [ -z "$WORKER" ]; then echo "[SKIP] Worker node not found."; exit 0; fi
if ssh -o BatchMode=yes -o ConnectTimeout=3 "$WORKER" 'systemctl stop kubelet' >/dev/null 2>&1; then
  echo "$WORKER" > "$STATE"
  echo "[READY] kubelet stopped on one worker. Diagnose it."
else
  echo "[SKIP] SSH/systemd control to worker is unavailable."
fi
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q14/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q14, then run:"
echo "        ./scripts/validate_question.sh 14"
}

q15() {
echo "============================================================"
echo " CKA Practice Set #1 - Q15"
echo "============================================================"
kubectl delete ns final --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl create ns final
kubectl -n final create deploy frontend --image=nginx:1.27 --replicas=3
kubectl -n final label deploy frontend app=frontend --overwrite
kubectl -n final patch deploy frontend -p '{"spec":{"selector":{"matchLabels":{"app":"frontend"}},"template":{"metadata":{"labels":{"app":"frontend"}}}}}' >/dev/null
kubectl -n final expose deploy frontend --name=frontend-svc --port=8080 --target-port=8080
kubectl -n final run client --image=busybox:1.36 --command -- sleep 3600
kubectl -n final wait --for=condition=Ready pod --all --timeout=60s || true
echo "[READY] Q15 broken targetPort prepared."
echo
echo "---------------------------- QUESTION ----------------------------"
cat "$ROOT_DIR/q15/question.md"
echo "------------------------------------------------------------------"
echo
echo "[START] Solve Q15, then run:"
echo "        ./scripts/validate_question.sh 15"
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
