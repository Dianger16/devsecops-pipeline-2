# DevSecOps Pipeline

Secure CI gates: Gitleaks (secrets), Semgrep (SAST), Trivy (deps, IaC, image). Build fails on HIGH/CRITICAL.

## Setup
1. Push to GitHub, enable Actions.
2. Settings > Branches > protect `main` > require checks: Secrets scan, SAST, Dependency scan, IaC scan, Container scan.
3. Local: `pip install pre-commit && pre-commit install`

## Prove it works
Test branch: add a fake hardcoded secret in app/main.py and a vulnerable dep (`requests==2.19.0`) in requirements.txt. Screenshot the failed run, then fix it.
# devsecops-pipeline-2
# devsecops-pipeline-2
