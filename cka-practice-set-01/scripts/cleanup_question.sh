#!/usr/bin/env bash
set -u

q1() {
echo "============================================================"
echo " Q1 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace omega"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns omega --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "[CLEAN] Q1"
echo "============================================================"
}

q2() {
echo "============================================================"
echo " Q2 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace app-config"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns app-config --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "[CLEAN] Q2"
echo "============================================================"
}

q3() {
echo "============================================================"
echo " Q3 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace storage-lab"
echo "  - PV q3-pv"
echo "  - StorageClass cka-manual"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns storage-lab --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl delete pv q3-pv --ignore-not-found >/dev/null 2>&1 || true
kubectl delete sc cka-manual --ignore-not-found >/dev/null 2>&1 || true
echo "[CLEAN] Q3"
echo "============================================================"
}

q4() {
echo "============================================================"
echo " Q4 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - Pod special-app"
echo "  - node taint workload=special:NoSchedule"
echo "  - node label workload"
echo
echo "[CLEANUP RESULT]"
kubectl delete pod special-app --ignore-not-found >/dev/null 2>&1 || true
for n in $(kubectl get nodes -o name | cut -d/ -f2); do
  kubectl taint node "$n" workload=special:NoSchedule- >/dev/null 2>&1 || true
  kubectl label node "$n" workload- >/dev/null 2>&1 || true
done
echo "[CLEAN] Q4"
echo "============================================================"
}

q5() {
echo "============================================================"
echo " Q5 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace scheduling"
echo "  - node label storage"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns scheduling --ignore-not-found --wait=false >/dev/null 2>&1 || true
for n in $(kubectl get nodes -o name | cut -d/ -f2); do kubectl label node "$n" storage- >/dev/null 2>&1 || true; done
echo "[CLEAN] Q5"
echo "============================================================"
}

q6() {
echo "============================================================"
echo " Q6 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace network-a"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns network-a --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "[CLEAN] Q6"
echo "============================================================"
}

q7() {
echo "============================================================"
echo " Q7 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace network-a"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns network-a --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "[CLEAN] Q7"
echo "============================================================"
}

q8() {
echo "============================================================"
echo " Q8 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespaces frontend-ns, database-ns, other-ns"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns frontend-ns database-ns other-ns --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "[CLEAN] Q8"
echo "============================================================"
}

q9() {
echo "============================================================"
echo " Q9 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace svc-test"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns svc-test --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "[CLEAN] Q9"
echo "============================================================"
}

q10() {
echo "============================================================"
echo " Q10 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace ingress-lab"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns ingress-lab --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "[CLEAN] Q10"
echo "============================================================"
}

q11() {
echo "============================================================"
echo " Q11 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace development"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns development --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "[CLEAN] Q11"
echo "============================================================"
}

q12() {
echo "============================================================"
echo " Q12 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - Static Pod manifest containing name=static-nginx"
echo
echo "[CLEANUP RESULT]"
DIR=$(awk '/staticPodPath:/ {print $2}' /var/lib/kubelet/config.yaml 2>/dev/null || true)
[ -z "$DIR" ] && DIR=/etc/kubernetes/manifests
for f in $(grep -rl 'name: static-nginx' "$DIR" 2>/dev/null || true); do rm -f "$f"; done
echo "[CLEAN] Q12"
echo "============================================================"
}

q13() {
echo "============================================================"
echo " Q13 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace repair"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns repair --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "[CLEAN] Q13"
echo "============================================================"
}

q14() {
echo "============================================================"
echo " Q14 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - restore worker kubelet if needed"
echo "  - temporary state file /tmp/cka-q14-node"
echo
echo "[CLEANUP RESULT]"
STATE=/tmp/cka-q14-node
if [ -f "$STATE" ]; then
  NODE=$(cat "$STATE")
  ssh -o BatchMode=yes -o ConnectTimeout=3 "$NODE" 'systemctl start kubelet' >/dev/null 2>&1 || true
  rm -f "$STATE"
fi
echo "[CLEAN] Q14"
echo "============================================================"
}

q15() {
echo "============================================================"
echo " Q15 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace final"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns final --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "[CLEAN] Q15"
echo "============================================================"
}

if [ "$#" -ne 1 ]; then echo "Usage: $0 <question-number|all>"; exit 1; fi
QUESTION="$1"
if [ "$QUESTION" = "all" ]; then
  for q in $(seq 1 15); do "$0" "$q" || true; done
  exit 0
fi
case "$QUESTION" in
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
  *) echo "Unknown question: $QUESTION"; exit 1 ;;
esac
