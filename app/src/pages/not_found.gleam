import components/button
import layout
import lustre/attribute.{class}
import lustre/element.{type Element}
import lustre/element/html.{div, h1, p, text}

pub fn page() -> Element(msg) {
  div([], [
    layout.page_head(title: "404 | 関数型まつり 2026"),
    content(),
  ])
}

fn content() -> Element(msg) {
  div([class("flex-1 flex items-center justify-center py-24")], [
    div([class("text-center")], [
      h1([class("text-7xl font-bold mb-6")], [text("404")]),
      p([class("text-xl mb-10 text-muted")], [
        text("ページが見つかりません"),
      ]),
      button.primary(label: "ホームに戻る", url: "/"),
    ]),
  ])
}
