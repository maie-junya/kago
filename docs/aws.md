# AWS の使い方とコスト

## 方針

- 普段の開発はローカル。AWS はインフラやデプロイの作業をするときだけ apply し、終わったら destroy
  - 常設：Terraform の state 置き場、ECR、ドメイン、DNS（Route 53）、ACM
  - 都度：それ以外（常時稼働だと月 60〜70 ドル程度）
- CI は push ごとに自動で実行し、デプロイは GitHub のボタンから実行（`workflow_dispatch`）する。destroy している間に push してもデプロイが失敗しないようにするため
- ECR はライフサイクルポリシーで古いイメージを消す
- 初めて使うサービスは、一度コンソールで作って設定項目を見てから消す。消し漏れはタグで探して CLI で消す
- NAT Gateway は使わず、Fargate をパブリックサブネットに置いて ALB からの通信だけを許可（実務ではプライベートサブネット ＋ NAT が定番）
- ドメインは必要になるフェーズ 10 で買う。初年度価格ではなく更新料で選ぶ

## 初期設定

Terraform で管理しない、手作業の設定。

- アカウント：新しい登録方法（Sign up for AWS (new)）で作られた。そのままだとリージョンがシドニー固定で、Organizations と Identity Center も AWS の管理になるため、有料プランに切り替えて「高度な機能」を有効化した（どちらも元に戻せない）
- 構成：AWS Organizations の下に次の 3 つ
  - 管理アカウント（Layla-Team Management Account）：請求、Budgets、SCP の管理だけに使う
  - kago（旧 Fresh Canvas）：kago のリソースを置く
  - Identity Delegated Admin：AWS が作った Identity Center の管理用。触らない
- ログイン：普段は Builder ID で settings.aws.com に入り、アカウントを選ぶ。Builder ID はルートユーザーの代わりに kago のアカウントを所有しているため、MFA を設定した。管理アカウントのルートユーザーは MFA を設定して復旧用にだけ使う
- CLI：`aws login --profile kago` でログインする。認証情報は一時的なもので、12 時間で切れる。アクセスキーは期限がなく、漏れると悪用され続けるため作らない
- リージョン：SCP の `RegionFloor` で、シドニー（ap-southeast-2）を東京（ap-northeast-1）に置き換えた
- 請求アラート：管理アカウントの Budgets で月次コスト予算を 5 ドルにし、実績 50%・100%、予測 100% でメール通知。クレジットは除外する（含めるとクレジットで相殺され、アラートが鳴らない）。画面では請求データがたまるまでクレジットを選べないため、CloudShell から CLI で作った
- フェーズ 5 の前に：SCP の `DenyIAMRestrictedActions` が残っていれば `iam:*Provider*` を外す（GitHub Actions の OIDC プロバイダーを作れないため）
