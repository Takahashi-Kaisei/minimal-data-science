# minimal-data-science

<a target="_blank" href="https://cookiecutter-data-science.drivendata.org/">
    <img src="https://img.shields.io/badge/CCDS-Project%20template-328F97?logo=cookiecutter" />
</a>


## 概要

このテンプレートリポジトリは、武蔵野大学データサイエンス学部に所属する学生向けのものです。

- 想定OS環境
    - ローカル: macOS（MPS）
    - リモート(GPUサーバー): Linux（CUDA）

- パッケージ管理
    - `uv`

## 特徴など

- **Python 3.13 固定運用**（[pyproject.toml](pyproject.toml)）
    - 変更するための手順は用意していないので、必要に応じて手動で変更すること。
- **OSごとにtorchを自動切り替え(environment markers)**
  - macOS: `torch>=2.10.0`
  - Linux: `torch==2.10.0+cu129`（PyTorch CUDA indexを使用）
    ※ 一般的には、ローカルでもGPUサーバーでもdocker containerを使用して開発することが多いが、PCが重くなったり、containerのbuildが面倒だったりのボトルネックが発生するため、ローカルではMPS版、GPUサーバーではCUDA版というように完全に切り分けて運用することを想定している。
- **Dev Container対応**
  - GPUサーバーでの環境構築を簡単にするため、VS CodeのDev Containersを利用可能にしている。（[.devcontainer/devcontainer.json](.devcontainer/devcontainer.json)）

---

## セットアップ（ローカル）

前提:
- `uv` インストール済み
- Python 3.13 系が利用可能

手順:
1. ターミナルにて以下のコマンドを実行

```bash
uv sync
```

セットアップ完了

---

## セットアップ（GPUサーバー）

前提:
- GPUサーバーにSSHでアクセス可能
- 自分のユーザーディレクトリにこのリポジトリをクローンしている。または、このリポジトリから派生したリポジトリをクローンしている。

1. SSHでGPUサーバーに接続
2. minimal-data-science(または、minimal-data-scienceから派生したリポジトリ)をカレントディレクトリとしてVS Codeで開く。
3. vscodeを開いた状態で、コマンドパレット(command + shift + p)から「Dev Containers: Rebuild Without Cache and Reopen in Container」を選択し、実行する。
    ※ ビルドには時間がかかるため、気長に待つこと。
4. コンテナ内のVS Codeターミナルで以下のコマンドを実行

```bash
uv sync
```

セットアップ完了

---

## ディレクトリ構成（抜粋）

```text
.
├── .devcontainer/ <- dev container関連の設定ファイルを格納するディレクトリ
├── data/ <- データセットを格納するディレクトリ
├── docs/ <- ドキュメントを格納するディレクトリ(現状は、かなり適当な運用)
├── notebooks/ <- Jupyter Notebookを格納するディレクトリ(001, 002, 003...のように、番号を振って管理することを想定している。)
├── src/minimal_data_science/ <- ソースコードを格納するディレクトリ(運用方法は未定)
├── tests/ <- テストコードを格納するディレクトリ(まだテストを走らせていない。運用方法は未定)
├── Dockerfile <- GPUサーバーでの開発環境を構築するためのDockerfileであり、できるだけシンプルな構成にしている。
├── Makefile <- 運用未定
└── pyproject.toml <- パッケージ管理ファイル。OSに依存するライブラリは、environment markersを用いて自動で切り替えるようにしている。
```

---

## ライセンス

このテンプレートリポジトリは、Cookiecutter Data Science をベースにして作成しており、MIT Licenseのもとで公開されている。

もし、このリポジトリをベースに新しいプロジェクトを作成した場合、そのプロジェクトもMIT Licenseのもとで公開する義務が発生するので注意すること。

※ [LICENSE](LICENSE) を参照
