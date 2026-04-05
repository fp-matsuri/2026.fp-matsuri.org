import gleam/list
import gleam/order
import gleam/string

pub type Member {
  Member(id: String)
}

fn compare(a: Member, b: Member) -> order.Order {
  string.compare(a.id, b.id)
}

pub fn leaders() {
  [
    Member("kazup0n"),
    Member("lagenorhynque"),
    Member("shomatan"),
    Member("ysaito8015"),
    Member("y047aka"),
  ]
  |> list.sort(by: compare)
}

pub fn staff() {
  [
    Member("ningen"),
    Member("thousanda"),
    Member("ik11235"),
    Member("valbeat"),
    Member("Shunki6733"),
    Member("Kamenleon"),
    Member("rabe1028"),
    Member("lmdexpr"),
    Member("kawagashira"),
    Member("KentaroKajiyama"),
    Member("ChenCMD"),
    Member("hrkd1316"),
    Member("unarist"),
    Member("You-saku"),
    Member("RyosukeDTomita"),
    Member("gawakawa"),
    Member("silasolla"),
    Member("stoneream"),
    Member("manabeai"),
    Member("nakokd"),
    Member("ar1ak1"),
    Member("Comamoca"),
    Member("reodon"),
  ]
  |> list.sort(by: compare)
}

pub fn github_url(member: Member) -> String {
  "https://github.com/" <> member.id
}

pub fn avatar_url(member: Member) -> String {
  "https://avatars.githubusercontent.com/" <> member.id <> "?s=80"
}
