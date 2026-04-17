# minimal-data-science

<a target="_blank" href="https://cookiecutter-data-science.drivendata.org/">
    <img src="https://img.shields.io/badge/CCDS-Project%20template-328F97?logo=cookiecutter" />
</a>


## 概要

このテンプレートは、武蔵野大学データサイエンス学部の学生向けに、
**ローカル（macOS / MPS）** と **リモート（Linux / CUDA）** を切り分けて運用できるように設計しています。

- 想定 OS
    - ローカル: macOS（MPS）
    - リモート（GPUサーバー）: Linux（CUDA）
- パッケージ管理（Package Management）: `uv`
- Python バージョン（Python Version）: **3.13 固定**

---

## このREADMEのゴール

このREADMEは、**初学者が最短で環境構築（Setup）を完了すること**を目的にしています。

1. まずは「クイックスタート（Quick Start）」を実行
2. うまくいかない場合は「トラブルシューティング（Troubleshooting）」を参照
3. 背景や詳細は「関連ドキュメント（Docs）」へ

---

## クイックスタート（Quick Start）

### 0) リポジトリセットアップ

- このリポジトリにアクセスし、右上の「Use this template」を押下し、このリポジトリを基盤に自分のリポジトリを作成します。
- 作成したリポジトリをクローンします。
    - ※ GPUサーバーではgitの問題でcloneできない可能性、cloneできてもuserが異なる可能性があります。(Troubleshooting参照)

### 1) ローカル（macOS / MPS）

前提（Prerequisites）:
- `uv` が使える
- Python 3.13 系が使える

手順:

```bash
uv sync
```

動作確認（Verification）:

```bash
uv run python -c "import torch; print(torch.__version__)"
uv run python -c "import torch; print(torch.backends.mps.is_available())"
```

> Apple Silicon 環境では `True` が期待値です。

### 2) GPUサーバー（Linux / CUDA + Dev Container）

前提（Prerequisites）:
- GPUサーバーに SSH 接続できる
- VS Code でこのリポジトリを開ける

手順:
1. SSH 接続先でこのリポジトリを VS Code で開く
2. コマンドパレット（`command + shift + p`）で
     `Dev Containers: Rebuild Without Cache and Reopen in Container` を実行
3. コンテナ内ターミナルで以下を実行

```bash
uv sync
```

動作確認（Verification）:

```bash
uv run python -c "import torch; print(torch.__version__)"
uv run python -c "import torch; print(torch.cuda.is_available())"
```

> GPUが正しく使える場合は `True` が期待値です。

---

## このテンプレートの特徴

- **Python 3.13 固定運用**（[pyproject.toml](pyproject.toml)）
- **OSごとに PyTorch を自動切り替え（Environment Markers）**
    - macOS: `torch>=2.10.0`
    - Linux: `torch==2.10.0+cu129`（PyTorch CUDA index を使用）
- **Dev Container 対応**（[.devcontainer/devcontainer.json](.devcontainer/devcontainer.json)）

---

## トラブルシューティング（Troubleshooting）

### GPUサーバーで`git clone`できない

ssh-agentなどを利用してローカルと同じユーザーでアクセスできるようにするとシームレスにcloneできます。(slackの#gpu端末利用者向けアナウンス を参照)

面倒な場合は以下の手順を踏む。
- ローカルでclone
- zip化
- `scp` or `rsync`でGPUサーバーにコピー
- unzipして展開

### `uv: command not found` が出る

- 症状: `uv sync` が実行できない
- 原因: `uv` が未インストール、またはPATH未設定
- 対処: `uv` をインストールし、シェルを再起動して再実行

### Dev Container のビルドが失敗する

- 症状: `Rebuild Without Cache` 実行時に途中で停止
- 原因: ネットワーク、リモートのストレージがいっぱい、etc.
- 対処:
    - ネットワークが原因 -> ネットワークを確認
    - リモートのストレージが原因 -> `df -h` で空き容量を確認。自分で対処できない場合はslackで相談

### `torch.backends.mps.is_available()` が `False` になる（macOS）

- 症状: MPS が使えない
- 原因: Intel Mac 利用、または環境依存
- 対処: Apple Silicon Mac であることを確認。それ以外ならMPSは使えないため、ローカルでGPUを使いたい場合は別途GPUサーバーを利用。

---

## 関連ドキュメント（Docs）

- Docker / CUDA運用の背景: [docs/docker-memo/001_dockerfile-best-practice.md](docs/docker-memo/001_dockerfile-best-practice.md)
- Copilot instructions の入口: [.github/copilot-instructions.md](.github/copilot-instructions.md)

---

## ディレクトリ構成（抜粋）

```text
.
├── .devcontainer/                    <- Dev Container 設定
├── data/                             <- データ（raw / external / processed）
├── docs/                             <- 背景など補足ドキュメント
├── notebooks/                        <- Notebook（実験・検証）
├── src/minimal_data_science/         <- Python モジュール
├── tests/                            <- テストコード
├── Dockerfile                        <- GPUサーバー向け開発環境
├── Makefile                          <- 未整備
└── pyproject.toml                    <- 依存関係・ツール設定
```

---

## ライセンス

このテンプレートは Cookiecutter Data Science をベースにしており、MIT License のもとで公開されています。

詳細は [LICENSE](LICENSE) を参照してください。
