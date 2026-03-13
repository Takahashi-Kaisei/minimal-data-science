# # 使いたいtorchのversionに合わせる。cudaのversionはそんなに気にしなくて良い。
# FROM pytorch/pytorch:2.9.1-cuda13.0-cudnn9-runtime

# # 最低限必要なツールをinstallする。devcontainerのfeaturesでcommon-utilsを入れているので、そこまで多くのツールは必要ないはず。
# RUN apt-get update \
#     && apt-get install -y --no-install-recommends \
#     vim \
#     wget \
#     locales \
#     && localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

# ENV LANG=ja_JP.UTF-8
# ENV LC_ALL=ja_JP.UTF-8
# ENV TZ=Asia/Tokyo

# WORKDIR /app

# COPY pyproject.toml uv.lock ./
# # uvから一部を持ってくる的なやつ。
# COPY --from=ghcr.io/astral-sh/uv:0.9.17 /uv /uvx /bin/

# # seedがあるとpipが入るよ。
# RUN uv venv --seed -p 3.13

# COPY requirements.txt .

# # RUN uv pip install --no-cache-dir -r requirements.txt
# # image内にキャッシュを保存する。肥大化したらdocker system prune
# RUN --mount=type=cache,target=/root/.cache/uv \
#     uv pip install -r requirements.txt

# COPY . .

# --- Build Stage ---

FROM ghcr.io/astral-sh/uv:0.9.17 AS uv_bin
FROM pytorch/pytorch:2.9.1-cuda13.0-cudnn9-runtime AS builder

COPY --from=uv_bin /uv /uvx /bin/

# 環境変数の設定
ENV UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=1 \
    UV_CACHE_DIR=/root/.cache/uv

WORKDIR /app

# 依存関係定義のコピー
COPY pyproject.toml uv.lock ./

# --mount=type=cache により、ホストのキャッシュを利用しつつイメージには含めない
# --no-install-project はライブラリのみを先にインストールするためのフラグ
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-install-project --no-dev

# --- Final Stage ---
FROM pytorch/pytorch:2.9.1-cuda13.0-cudnn9-runtime

# 最小限のランタイム設定
RUN apt-get update && apt-get install -y --no-install-recommends \
    locales \
    && localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=ja_JP.UTF-8 \
    LC_ALL=ja_JP.UTF-8 \
    TZ=Asia/Tokyo \
    PATH="/app/.venv/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /workspaces/

# builderから「純粋な仮想環境」だけをコピーする
COPY --from=builder /app/.venv /app/.venv

# ソースコードは起動時にマウントすることを前提とし、ここではコピーしない
# （または開発中の最新版を入れたい場合のみ COPY . . する）
