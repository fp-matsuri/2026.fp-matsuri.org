import gleam/dict.{type Dict}
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import jot
import simplifile

pub type Sponsor {
  Sponsor(
    name: String,
    image: String,
    href: String,
    plan: SponsorPlan,
    description: String,
  )
}

pub type SponsorPlan {
  Platinum
  Gold
  Silver
  Logo
}

const sponsors_dir = "content/sponsors"

pub fn load_all() -> fn(SponsorPlan) -> List(Sponsor) {
  case simplifile.read_directory(sponsors_dir) {
    Error(_) -> {
      io.println("Warning: could not read " <> sponsors_dir)
      fn(_) { [] }
    }
    Ok(files) -> {
      let all =
        files
        |> list.filter(fn(f) { string.ends_with(f, ".dj") })
        |> list.filter_map(fn(filename) {
          let path = sponsors_dir <> "/" <> filename
          case load_sponsor(path) {
            Ok(s) -> Ok(s)
            Error(Nil) -> {
              io.println("Warning: failed to parse " <> path)
              Error(Nil)
            }
          }
        })
        |> list.group(fn(s) { s.plan })
      fn(plan) { dict.get(all, plan) |> result.unwrap([]) }
    }
  }
}

fn load_sponsor(path: String) -> Result(Sponsor, Nil) {
  use content <- result.try(simplifile.read(path) |> result.replace_error(Nil))
  use #(metadata, body) <- result.try(parse_frontmatter(content))
  use name <- result.try(dict.get(metadata, "name"))
  use image <- result.try(dict.get(metadata, "image"))
  use plan_str <- result.try(dict.get(metadata, "plan"))
  use plan <- result.try(parse_plan(plan_str))
  let href = result.unwrap(dict.get(metadata, "href"), "")
  let description = case string.trim(body) {
    "" -> ""
    trimmed -> jot.to_html(trimmed)
  }
  Ok(Sponsor(name:, image:, href:, plan:, description:))
}

fn parse_frontmatter(
  content: String,
) -> Result(#(Dict(String, String), String), Nil) {
  case string.split(content, "\n") {
    ["---", ..rest] -> {
      let #(meta, body) = list.split_while(rest, fn(l) { l != "---" })
      let body = list.drop(body, 1) |> string.join("\n")
      let meta =
        meta
        |> list.filter_map(fn(line) {
          string.split_once(line, ":")
          |> result.map(fn(pair) {
            let #(key, value) = pair
            #(string.trim(key), string.trim(value))
          })
        })
        |> dict.from_list()
      Ok(#(meta, body))
    }
    _ -> Error(Nil)
  }
}

fn parse_plan(s: String) -> Result(SponsorPlan, Nil) {
  case string.lowercase(string.trim(s)) {
    "platinum" -> Ok(Platinum)
    "gold" -> Ok(Gold)
    "silver" -> Ok(Silver)
    "logo" -> Ok(Logo)
    _ -> Error(Nil)
  }
}
