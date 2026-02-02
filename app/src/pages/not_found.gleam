import components/button
import layout.{type Page, Page}
import lustre/attribute.{class}
import lustre/element/html.{div, h1, p, text}

pub fn page() -> Page(msg) {
  Page(title: "404 | 関数型まつり2026", body: [
    div([class("flex-1 flex items-center justify-center py-24")], [
      div([class("text-center")], [
        h1([class("text-7xl font-bold mb-6")], [text("404")]),
        p([class("text-xl mb-10 text-muted")], [
          text("ページが見つかりません"),
        ]),
        button.primary(label: "ホームに戻る", url: "/"),
      ]),
    ]),
  ])
}
