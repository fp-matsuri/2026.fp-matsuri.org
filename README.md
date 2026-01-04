# 2026.fp-matsuri.org

2026年に開催を予定している『関数型まつり』の公式ウェブサイトです。

## 技術スタック

- [Gleam](https://gleam.run/) - 型安全な関数型プログラミング言語
- [Lustre](https://hexdocs.pm/lustre/) - GleamのWebフレームワーク
- [Tailwind CSS](https://tailwindcss.com/) - ユーティリティファーストCSSフレームワーク
- [daisyUI](https://daisyui.com/) - TailwindベースのUIコンポーネントライブラリ
- [Playwright](https://playwright.dev/) - E2Eテストフレームワーク

## 開発環境のセットアップ

### Nixを使用する場合

```sh
nix develop
npm install
```

### 手動でセットアップする場合

以下をインストールしてください:

- Erlang
- Gleam
- Node.js

## 開発

### 開発サーバーの起動

```sh
cd app
gleam run -m lustre/dev start
```

ブラウザで http://localhost:1234 を開いてください。

## テスト

### E2Eテストの実行

Playwrightを使用したビジュアルリグレッションテストを実行できます。

```sh
npm install
npm test
```

テストは開発サーバーを自動的に起動し、Google ChromeとMobile Safariで実行されます。

### テストレポートの確認

```sh
npx playwright show-report
```
