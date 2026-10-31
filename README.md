# kago

Web アプリを作りながら、フロントからインフラまで学ぶためのリポジトリ。

## 題材

EC サイト。興味がなくても仕様を想像しやすく、トランザクションや外部サービス連携など、業務系のバックエンドでよく出てくる論点が多い。題材に合わない機能も気にせず足す。

## 技術スタック

| 領域           | 選定                                                |
| -------------- | --------------------------------------------------- |
| フレームワーク | Next.js（App Router）                               |
| 認証           | Better Auth                                         |
| DB             | PostgreSQL（本番は RDS、ローカルは Docker Compose） |
| ORM            | Drizzle                                             |
| インフラ       | AWS（ECS Fargate ＋ ALB ＋ RDS）                    |
| IaC            | Terraform                                           |
| CI/CD          | GitHub Actions                                      |
| テスト         | Vitest（DB を使う統合テスト）、Playwright（E2E）    |

## ローカルで動かす

mise と Docker Desktop を入れておく。

```sh
mise install # mise.toml の Node と pnpm を入れる
pnpm install
pnpm dev     # http://localhost:3000
```

本番と同じコンテナで確かめるとき：

```sh
docker build -t kago .
docker run --rm -p 3000:3000 kago
```

## ドキュメント

- [ロードマップ](docs/roadmap.md)
- [AWS の使い方とコスト](docs/aws.md)
- [開発のルール](CONTRIBUTING.md)
