#!/usr/bin/env bash
# Negative tests: each bad manifest MUST be rejected.
set -u
fail=0
for f in tests-k8s/bad-pod-privileged.yaml "$@"; do
  if kubectl apply -f "$f" >/dev/null 2>&1; then
    echo "FAIL: $f was admitted (should be blocked)"
    kubectl delete -f "$f" --ignore-not-found >/dev/null 2>&1
    fail=1
  else
    echo "PASS: $f rejected"
  fi
done
exit $fail
