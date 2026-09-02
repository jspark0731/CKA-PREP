#!/usr/bin/env bash
set -u
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

q1() {
echo "============================================================"
echo " CKA Practice Set #2 - Q1 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace rollout-lab"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns rollout-lab --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "============================================================"
}

q2() {
echo "============================================================"
echo " CKA Practice Set #2 - Q2 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace config-volume"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns config-volume --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "============================================================"
}

q3() {
echo "============================================================"
echo " CKA Practice Set #2 - Q3 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace secret-lab"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns secret-lab --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "============================================================"
}

q4() {
echo "============================================================"
echo " CKA Practice Set #2 - Q4 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace autoscale"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns autoscale --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "============================================================"
}

q5() {
echo "============================================================"
echo " CKA Practice Set #2 - Q5 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - Pod batch-job"
echo "  - node taint dedicated=batch:NoSchedule"
echo "  - node label set2-batch"
echo
echo "[CLEANUP RESULT]"
kubectl delete pod batch-job --ignore-not-found >/dev/null 2>&1 || true
for n in $(kubectl get nodes -o name | cut -d/ -f2); do kubectl taint node "$n" dedicated=batch:NoSchedule- >/dev/null 2>&1 || true; kubectl label node "$n" set2-batch- >/dev/null 2>&1 || true; done
echo "============================================================"
}

q6() {
echo "============================================================"
echo " CKA Practice Set #2 - Q6 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace dns-lab"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns dns-lab --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "============================================================"
}

q7() {
echo "============================================================"
echo " CKA Practice Set #2 - Q7 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace egress-lab"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns egress-lab --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "============================================================"
}

q8() {
echo "============================================================"
echo " CKA Practice Set #2 - Q8 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespaces team-a, team-b, database"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns team-a team-b database --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "============================================================"
}

q9() {
echo "============================================================"
echo " CKA Practice Set #2 - Q9 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace qa"
echo "  - ClusterRole pod-log-reader"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns qa --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl delete clusterrole pod-log-reader --ignore-not-found >/dev/null 2>&1 || true
echo "============================================================"
}

q10() {
echo "============================================================"
echo " CKA Practice Set #2 - Q10 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace pv-lab"
echo "  - PV set2-pv"
echo "  - StorageClass set2-manual"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns pv-lab --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl delete pv set2-pv --ignore-not-found >/dev/null 2>&1 || true
kubectl delete sc set2-manual --ignore-not-found >/dev/null 2>&1 || true
echo "============================================================"
}

q11() {
echo "============================================================"
echo " CKA Practice Set #2 - Q11 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace kustomize-lab"
echo "  - q11/overlay/kustomization.yaml"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns kustomize-lab --ignore-not-found --wait=false >/dev/null 2>&1 || true
rm -f "$ROOT_DIR/q11/overlay/kustomization.yaml"
echo "============================================================"
}

q12() {
echo "============================================================"
echo " CKA Practice Set #2 - Q12 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace ingress2"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns ingress2 --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "============================================================"
}

q13() {
echo "============================================================"
echo " CKA Practice Set #2 - Q13 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace repair2"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns repair2 --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "============================================================"
}

q14() {
echo "============================================================"
echo " CKA Practice Set #2 - Q14 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace schedule-repair"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns schedule-repair --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "============================================================"
}

q15() {
echo "============================================================"
echo " CKA Practice Set #2 - Q15 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace final2"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns final2 --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "============================================================"
}

if [ "$#" -ne 1 ]; then echo "Usage: $0 <question-number|all>"; exit 1; fi
if [ "$1" = "all" ]; then for q in $(seq 1 15); do "$0" "$q" || true; done; exit 0; fi
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
