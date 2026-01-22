import { defineConfig } from "vite";
import tailwindcss from "@tailwindcss/vite";
import { resolve } from "path";
import { fileURLToPath } from "url";
import { readdirSync, existsSync, watch } from "fs";
import { execSync } from "child_process";

const __dirname = fileURLToPath(new URL(".", import.meta.url));
const buildDir = "arctic_build";

// arctic_build配下のHTMLファイルを自動検出
function collectInputs() {
  const inputs = {};

  // arctic_buildディレクトリが存在しない場合は空のオブジェクトを返す
  if (!existsSync(buildDir)) {
    return inputs;
  }

  const indexPath = `${buildDir}/index.html`;
  if (existsSync(indexPath)) {
    inputs.main = resolve(__dirname, indexPath);
  }

  const notFoundPath = `${buildDir}/404.html`;
  if (existsSync(notFoundPath)) {
    inputs["404"] = resolve(__dirname, notFoundPath);
  }

  readdirSync(buildDir, { withFileTypes: true })
    .filter((dirent) => dirent.isDirectory())
    .filter((dirent) => !dirent.name.startsWith("."))
    .filter((dirent) => dirent.name !== "src")
    .forEach((dirent) => {
      const pagePath = `${buildDir}/${dirent.name}/index.html`;
      if (existsSync(pagePath)) {
        inputs[dirent.name] = resolve(__dirname, pagePath);
      }
    });

  return inputs;
}

// src/ディレクトリの.gleamファイルを監視するカスタムプラグイン
function gleamWatchPlugin() {
  let watcher = null;

  return {
    name: "gleam-watch",
    configureServer(server) {
      const srcDir = resolve(__dirname, "src");

      // src/ディレクトリを再帰的に監視
      watcher = watch(srcDir, { recursive: true }, (eventType, filename) => {
        if (filename && filename.endsWith(".gleam")) {
          console.log(`\n[gleam-watch] ${filename} changed, rebuilding...`);
          try {
            // ArcticのSSGビルドを実行してHTMLを再生成
            console.log("$ gleam run -m build");
            const out = execSync("gleam run -m build", {
              encoding: "utf8",
              cwd: __dirname,
            });
            console.log(out);
            // CSSファイルをコピー
            execSync(
              "mkdir -p arctic_build/src && cp src/app.css arctic_build/src/",
              {
                encoding: "utf8",
                cwd: __dirname,
              },
            );
            // ブラウザをリロード
            server.ws.send({ type: "full-reload" });
          } catch (error) {
            console.error("[gleam-watch] Build failed:", error.message);
          }
        }
      });

      console.log("[gleam-watch] Watching src/ for .gleam file changes");
    },
    closeBundle() {
      if (watcher) {
        watcher.close();
      }
    },
  };
}

export default defineConfig({
  plugins: [gleamWatchPlugin(), tailwindcss()],
  root: buildDir,
  publicDir: resolve(__dirname, "public"),
  build: {
    outDir: ".",
    emptyOutDir: false,
    rollupOptions: {
      input: collectInputs(),
    },
  },
  server: {
    port: 1234,
    open: true,
  },
});
