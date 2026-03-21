FROM nvidia/cuda:13.2.0-cudnn-devel-ubuntu24.04
COPY --from=ghcr.io/astral-sh/uv:0.10.12 /uv /uvx /bin/

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENV UV_PYTHON_INSTALL_DIR=/python
