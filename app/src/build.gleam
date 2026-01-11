import gleam/io
import lustre/ssg
import pages/code_of_conduct
import pages/home
import pages/not_found

pub fn main() {
  let result =
    ssg.new("dist")
    |> ssg.add_static_dir("assets")
    |> ssg.add_static_route("/", home.page())
    |> ssg.add_static_route("/code-of-conduct", code_of_conduct.page())
    |> ssg.add_static_route("/404", not_found.page())
    |> ssg.use_index_routes
    |> ssg.build

  case result {
    Ok(_) -> io.println("Build completed successfully!")
    Error(_err) -> {
      io.println("Build failed")
      Nil
    }
  }
}
