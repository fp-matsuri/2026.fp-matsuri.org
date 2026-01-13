import gleam/io
import gleam/string
import lustre/element
import lustre/ssg
import pages/code_of_conduct
import pages/home
import pages/not_found
import simplifile

pub fn main() {
  // Build main pages with index routes
  let result =
    ssg.new("dist")
    |> ssg.add_static_dir("assets")
    |> ssg.use_index_routes
    |> ssg.add_static_route("/", home.page())
    |> ssg.add_static_route("/code-of-conduct/", code_of_conduct.page())
    |> ssg.build

  case result {
    Ok(_) -> {
      // Write 404.html separately as a flat file
      let html_content =
        "<!doctype html>\n" <> element.to_string(not_found.page())
      let result_404 = simplifile.write("dist/404.html", html_content)

      case result_404 {
        Ok(_) -> io.println("Build completed successfully!")
        Error(err) -> {
          io.println("404 build failed: " <> string.inspect(err))
          Nil
        }
      }
    }
    Error(err) -> {
      io.println("Build failed: " <> string.inspect(err))
      Nil
    }
  }
}
