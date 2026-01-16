import arctic/build
import arctic/config
import gleam/io
import pages/code_of_conduct
import pages/home
import pages/not_found
import simplifile
import snag

pub fn main() {
  // Arctic設定を構築（SSGモード）
  let site_config =
    config.new()
    |> config.home_renderer(fn(_) { home.page() })
    |> config.add_main_page("code-of-conduct", code_of_conduct.page())
    |> config.add_main_page("404", not_found.page())

  // ビルド実行
  case build.build(site_config) {
    Ok(_) -> {
      // アセットをコピー
      let _ = simplifile.copy_directory("assets", "arctic_build")

      // 404ページをルートにコピー（Cloudflare Pages等で必要）
      let _ =
        simplifile.copy_file(
          "arctic_build/404/index.html",
          "arctic_build/404.html",
        )

      io.println("Build completed successfully!")
    }
    Error(err) -> {
      io.println("Build failed: " <> snag.pretty_print(err))
    }
  }
}
