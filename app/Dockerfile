# syntax=docker/dockerfile:1
# Pin by digest in real use: docker buildx imagetools inspect python:3.11-slim
FROM python:3.11-slim AS builder
ENV PIP_NO_CACHE_DIR=1 PIP_DISABLE_PIP_VERSION_CHECK=1
WORKDIR /build
COPY requirements.txt .
RUN pip install --target=/deps -r requirements.txt

# Distroless: no shell, no package manager, non-root. Python minor version must match builder (3.11).
FROM gcr.io/distroless/python3-debian12:nonroot
WORKDIR /app
COPY --from=builder /deps /deps
COPY main.py .
ENV PYTHONPATH=/deps PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
USER 65532:65532
EXPOSE 8000
# Health checks are done by Kubernetes probes (no curl/shell in distroless)
ENTRYPOINT ["python3", "-m", "uvicorn"]
CMD ["main:app", "--host", "0.0.0.0", "--port", "8000"]
