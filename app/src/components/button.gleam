import gleam/list
import gleam/string
import lustre/attribute.{attribute, class, href, rel, target}
import lustre/element.{type Element}
import lustre/element/html.{a, text}
import lustre/element/svg

pub fn primary(label label: String, url url: String) -> Element(msg) {
  let base_attrs = [
    href(url),
    class(
      "btn btn-primary rounded-full px-12 py-7 gap-2 font-normal border-none shadow-none",
    ),
  ]
  let attrs = case is_external_link(url) {
    True ->
      list.append(base_attrs, [target("_blank"), rel("noopener noreferrer")])
    False -> base_attrs
  }
  a(attrs, case is_external_link(url) {
    True -> [text(label), external_link_icon()]
    False -> [text(label)]
  })
}

fn external_link_icon() -> Element(msg) {
  svg.svg(
    [
      class("w-4 h-4"),
      attribute("fill", "none"),
      attribute("stroke", "currentColor"),
      attribute("viewBox", "0 0 24 24"),
      attribute("xmlns", "http://www.w3.org/2000/svg"),
    ],
    [
      svg.path([
        attribute("stroke-linecap", "round"),
        attribute("stroke-linejoin", "round"),
        attribute("stroke-width", "2"),
        attribute(
          "d",
          "M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14",
        ),
      ]),
    ],
  )
}

fn is_external_link(url: String) -> Bool {
  string.starts_with(url, "http://") || string.starts_with(url, "https://")
}
