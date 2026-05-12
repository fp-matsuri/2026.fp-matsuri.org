import gleam/io
import gleam/list
import gleam/result
import gleam/string
import jot
import lustre/ssg/djot
import simplifile
import tom

pub type Sponsor {
  Sponsor(
    slug: String,
    name: String,
    image: String,
    href: String,
    plan: SponsorPlan,
    kind: SponsorKind,
    description: String,
  )
}

pub type SponsorPlan {
  Platinum
  Gold
  Silver
  Logo
  Support
  Cheerleader
}

pub type SponsorKind {
  Individual
  Community
}

const sponsors_dir = "content/sponsors"

pub fn platinum_sponsors() -> List(Sponsor) {
  all_sponsors(Platinum)
}

pub fn gold_sponsors() -> List(Sponsor) {
  all_sponsors(Gold)
}

pub fn silver_sponsors() -> List(Sponsor) {
  all_sponsors(Silver)
}

pub fn logo_sponsors() -> List(Sponsor) {
  all_sponsors(Logo)
}

pub fn support_sponsors() -> List(Sponsor) {
  all_sponsors(Support)
}

pub fn cheerleader_sponsors() -> List(Sponsor) {
  all_sponsors(Cheerleader)
}

fn all_sponsors(plan) -> List(Sponsor) {
  case simplifile.read_directory(sponsors_dir) {
    Error(_) -> {
      io.println("Warning: could not read " <> sponsors_dir)
      []
    }
    Ok(files) ->
      files
      |> list.filter(fn(f) { string.ends_with(f, ".dj") })
      |> list.filter_map(fn(filename) {
        let path = sponsors_dir <> "/" <> filename
        let slug = string.drop_end(filename, 3)
        case
          {
            use content <- result.try(
              simplifile.read(path)
              |> result.replace_error("Failed to read " <> path),
            )
            parse(slug, content)
          }
        {
          Ok(s) -> Ok(s)
          Error(msg) -> {
            io.println_error(
              "Error parsing sponsor file " <> path <> ": " <> msg,
            )
            Error(Nil)
          }
        }
      })
      |> list.filter(fn(s) { s.plan == plan })
  }
}

pub fn parse(slug: String, content: String) -> Result(Sponsor, String) {
  use metadata <- result.try(
    djot.metadata(content) |> result.replace_error("Invalid TOML frontmatter"),
  )
  let get = fn(key) {
    tom.get_string(metadata, [key]) |> result.replace_error("Missing " <> key)
  }
  use name <- result.try(get("name"))
  use image <- result.try(get("image"))
  use plan_str <- result.try(get("plan"))
  use plan <- result.try(parse_plan(plan_str))
  let href = tom.get_string(metadata, ["href"]) |> result.unwrap("")
  let kind =
    tom.get_string(metadata, ["kind"])
    |> result.map_error(fn(_) { "" })
    |> result.try(parse_kind)
    |> result.unwrap(Individual)
  let description =
    djot.content(content)
    |> string.trim
    |> jot.to_html
  Ok(Sponsor(slug:, name:, image:, href:, plan:, kind:, description:))
}

fn parse_plan(s: String) -> Result(SponsorPlan, String) {
  case string.lowercase(string.trim(s)) {
    "platinum" -> Ok(Platinum)
    "gold" -> Ok(Gold)
    "silver" -> Ok(Silver)
    "logo" -> Ok(Logo)
    "support" -> Ok(Support)
    "cheerleader" -> Ok(Cheerleader)
    s -> Error("Unknown sponsor plan: " <> s)
  }
}

fn parse_kind(s: String) -> Result(SponsorKind, String) {
  case string.lowercase(string.trim(s)) {
    "individual" -> Ok(Individual)
    "community" -> Ok(Community)
    s -> Error("Unknown sponsor kind: " <> s)
  }
}
