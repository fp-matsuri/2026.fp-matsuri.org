import arctic/build
import arctic/config
import gleam/io
import layout
import pages/code_of_conduct
import pages/home
import pages/not_found
import pages/sponsors
import simplifile
import snag

pub fn main() {
  let site_config =
    config.new()
    |> config.home_renderer(fn(_) { layout.render_page(home.page()) })
    |> config.add_main_page(
      "code-of-conduct",
      layout.render_page(code_of_conduct.page()),
    )
    |> config.add_main_page("sponsors", layout.render_page(sponsors.page()))
    |> config.add_main_page("404", layout.render_page(not_found.page()))
    |> config.add_spa_frame(layout.spa_frame)

  case build.build(site_config) {
    Ok(_) -> {
      let _ =
        simplifile.rename(
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
