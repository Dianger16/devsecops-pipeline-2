# Docker + K8s hardening: proof checklist

Run: `make docker-build docker-scan` then `make cluster deploy test-policies verify-rbac`
Then: `make kyverno` (wait for pods), `make policies`, `kubectl apply -f k8s/tests/bad-pod-latest.yaml` (must fail).

Capture for the portfolio:
1. Image size + CVE count: old Dockerfile (python:slim) vs distroless multi-stage.
2. `make docker-run` working with read-only fs and all caps dropped.
3. Privileged pod rejected by Pod Security `restricted`.
4. NetworkPolicy test: `kubectl -n secure-app run t --rm -it --image=busybox:1.36 -- wget -T3 -O- demo-app` fails (needs runAsNonRoot overrides, or test from a permitted namespace).
5. `make verify-rbac` output.
6. Kyverno blocking `:latest` and unsigned images.
7. Green `Docker and K8s checks` workflow.
