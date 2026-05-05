# CLAUDE.md

このファイルは、Claude Code (claude.ai/code) がこのリポジトリで作業する際のガイダンスを提供します。

## 技術スタック

- **バックエンド**: Rails 8.1.3 (API-only)、PostgreSQL、RSpec、RuboCop、Brakeman
- **フロントエンド**: Next.js 16 (React 19)、TypeScript、Tailwind CSS 4、NextAuth
- **認証**: Google OAuth 2.0 → Rails JWT 交換
- **インフラ**: Docker Compose (バックエンド + PostgreSQL)

## コマンド

### バックエンド（Dockerコンテナ上で実行）

バックエンド関連のコマンドは必ず `docker compose exec app` 経由でコンテナ上で実行すること。

```bash
docker compose exec app bundle install
docker compose exec app rails db:create && docker compose exec app rails db:migrate

docker compose exec app bundle exec rspec                              # 全テスト実行
docker compose exec app bundle exec rspec spec/path/to_spec.rb         # 単一ファイルのテスト実行
docker compose exec app bundle exec rubocop                            # リント
docker compose exec app bundle exec brakeman                           # セキュリティスキャン
```

### フロントエンド (`cd frontend`)

```bash
npm install
npm run dev      # 開発サーバー（ポート 3000）
npm run build
npm run lint
```

### Docker

```bash
docker compose up --build        # バックエンド + PostgreSQL を起動
```

バックエンド: `http://localhost:3001`、フロントエンド（別途起動）: `http://localhost:3000`

## アーキテクチャ

### 認証フロー

1. Next.js がユーザーを Google OAuth にリダイレクト
2. NextAuth がコールバックで Google ID トークンを受け取る
3. フロントエンドが ID トークンを Rails の `POST /api/auth/google` に送信
4. Rails が `google-id-token` gem を使ってトークンを検証し、ユーザーをupsertして JWT を返す
5. NextAuth が JWT をセッションに保存。以降のリクエストは `Authorization: Bearer {jwt}` を付与
6. `ApplicationController#authenticate_user!`（before_action）が JWT をデコードして `current_user` をセット

### バックエンド構造

- `ApplicationController`: JWT デコード → `current_user` のセット。全コントローラーが継承
- `TasksController`: 標準的な CRUD。常に `current_user.tasks` にスコープ
- `Api::AuthController`: 認証をスキップ。Google トークン検証と JWT 発行を担当
- `User`: `has_many :tasks, dependent: :destroy`。`provider_name` と `provider_uid` を保持
- `Task`: `belongs_to :user`。フィールド: `title`（必須）、`started_at`、`finished_at`、`is_completed`

### フロントエンド構造

- `app/api/auth/[...nextauth]/route.ts`: 認証の中核。Google プロバイダー設定、バックエンドとのトークン交換、JWT のセッション永続化
- `app/providers.tsx`: `SessionProvider` のラッパー
- `app/page.tsx`: エントリーポイント。セッション状態に応じた条件付きレンダリング
- バックエンドへの全 API 呼び出しで `Authorization: Bearer {session.accessToken}` を使用

### データベーススキーマ

```
users:  id, name, email, provider_name, provider_uid, timestamps
tasks:  id, title, started_at, finished_at, is_completed, user_id (FK), timestamps
```

## CI

`backend/` に変更がある PR / `main` へのプッシュ時に GitHub Actions が実行される:

1. Brakeman セキュリティスキャン
2. RuboCop リント
3. RSpec テスト（PostgreSQL サービス付き）

Dependabot / Renovate によるパッチアップデートは自動マージされる。
