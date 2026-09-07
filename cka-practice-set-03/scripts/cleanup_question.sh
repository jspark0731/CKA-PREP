#!/usr/bin/env bash
set -u
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

q1() {
echo "============================================================"
echo " CKA Practice Set #3 - Q1 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace rollout3"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns rollout3 --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "[CLEAN] Q1"
echo "============================================================"
}

q2() {
echo "============================================================"
echo " CKA Practice Set #3 - Q2 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace mixed-config"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns mixed-config --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "[CLEAN] Q2"
echo "============================================================"
}

q3() {
echo "============================================================"
echo " CKA Practice Set #3 - Q3 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace schedule3"
echo "  - node label tier"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns schedule3 --ignore-not-found --wait=false >/dev/null 2>&1 || true; for n in $(kubectl get nodes -o name | cut -d/ -f2); do kubectl label node "$n" tier- >/dev/null 2>&1 || true; done
echo "[CLEAN] Q3"
echo "============================================================"
}

q4() {
echo "============================================================"
echo " CKA Practice Set #3 - Q4 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace hpa3"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns hpa3 --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "[CLEAN] Q4"
echo "============================================================"
}

q5() {
echo "============================================================"
echo " CKA Practice Set #3 - Q5 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespaces dev-a/dev-b"
echo "  - ClusterRole config-reader"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns dev-a dev-b --ignore-not-found --wait=false >/dev/null 2>&1 || true; kubectl delete clusterrole config-reader --ignore-not-found >/dev/null 2>&1 || true
echo "[CLEAN] Q5"
echo "============================================================"
}

q6() {
echo "============================================================"
echo " CKA Practice Set #3 - Q6 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace svc3"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns svc3 --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "[CLEAN] Q6"
echo "============================================================"
}

q7() {
echo "============================================================"
echo " CKA Practice Set #3 - Q7 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace net3"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns net3 --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "[CLEAN] Q7"
echo "============================================================"
}

q8() {
echo "============================================================"
echo " CKA Practice Set #3 - Q8 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespaces client-a/client-b/db3"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns client-a client-b db3 --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "[CLEAN] Q8"
echo "============================================================"
}

q9() {
echo "============================================================"
echo " CKA Practice Set #3 - Q9 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace storage3"
echo "  - PV pv3"
echo "  - StorageClass manual3"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns storage3 --ignore-not-found --wait=false >/dev/null 2>&1 || true; kubectl delete pv pv3 --ignore-not-found >/dev/null 2>&1 || true; kubectl delete sc manual3 --ignore-not-found >/dev/null 2>&1 || true
echo "[CLEAN] Q9"
echo "============================================================"
}

q10() {
echo "============================================================"
echo " CKA Practice Set #3 - Q10 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace kustom3"
echo "  - q10 overlay files"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns kustom3 --ignore-not-found --wait=false >/dev/null 2>&1 || true; rm -f "$ROOT_DIR/q10/overlay/kustomization.yaml" "$ROOT_DIR/q10/overlay/patch.yaml"
echo "[CLEAN] Q10"
echo "============================================================"
}

q11() {
echo "============================================================"
echo " CKA Practice Set #3 - Q11 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace crd3"
echo "  - CRD backups.example.com"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns crd3 --ignore-not-found --wait=false >/dev/null 2>&1 || true; kubectl delete crd backups.example.com --ignore-not-found >/dev/null 2>&1 || true
echo "[CLEAN] Q11"
echo "============================================================"
}

q12() {
echo "============================================================"
echo " CKA Practice Set #3 - Q12 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace gateway3"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns gateway3 --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "[CLEAN] Q12"
echo "============================================================"
}

q13() {
echo "============================================================"
echo " CKA Practice Set #3 - Q13 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace repair3"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns repair3 --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "[CLEAN] Q13"
echo "============================================================"
}

q14() {
echo "============================================================"
echo " CKA Practice Set #3 - Q14 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - audit-web static Pod manifest"
echo
echo "[CLEANUP RESULT]"
DIR=$(awk '/staticPodPath:/ {print $2}' /var/lib/kubelet/config.yaml 2>/dev/null || true); [ -z "$DIR" ] && DIR=/etc/kubernetes/manifests; for f in $(grep -rl 'name: audit-web' "$DIR" 2>/dev/null || true); do rm -f "$f"; done
echo "[CLEAN] Q14"
echo "============================================================"
}

q15() {
echo "============================================================"
echo " CKA Practice Set #3 - Q15 CLEANUP"
echo "============================================================"
echo "[DELETE / RESTORE TARGETS]"
echo "  - namespace final3"
echo
echo "[CLEANUP RESULT]"
kubectl delete ns final3 --ignore-not-found --wait=false >/dev/null 2>&1 || true
echo "[CLEAN] Q15"
echo "============================================================"
}

if [ "$#" -ne 1 ]; then echo "Usage: $0 <question-number|all>"; exit 1; fi
if [ "$1" = all ]; then for q in $(seq 1 15); do "$0" "$q" || true; done; exit 0; fi
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