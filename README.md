# 2026.fp-matsuri.org

2026年に開催を予定している『関数型まつり』の公式ウェブサイトです。

## 技術スタック

- [Gleam](https://gleam.run/) - 型安全な関数型プログラミング言語
- [Lustre](https://hexdocs.pm/lustre/) - GleamのWebフレームワーク
- [Tailwind CSS](https://tailwindcss.com/) - ユーティリティファーストCSSフレームワーク
- [daisyUI](https://daisyui.com/) - TailwindベースのUIコンポーネントライブラリ

## 開発環境のセットアップ

### Nixを使用する場合

```sh
nix develop
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

### ビルド

```sh
cd app
gleam run -m lustre/dev build app
```

ビルド成果物は `app/dist/` ディレクトリに出力されます。
