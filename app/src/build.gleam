import arctic/build
import arctic/config
import gleam/io
import layout
import pages/code_of_conduct
import pages/home
import pages/not_found
import simplifile
import snag

pub fn main() {
  let site_config =
    config.new()
    |> config.home_renderer(fn(_) { home.page() })
    |> config.add_main_page("code-of-conduct", code_of_conduct.page())
    |> config.add_main_page("404", not_found.page())
    |> config.add_spa_frame(layout.spa_frame)

  case build.build(site_config) {
    Ok(_) -> {
      let _ = simplifile.copy_directory("assets", "arctic_build")
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
