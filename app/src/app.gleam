import cloud
import code_of_conduct
import gleam/list
import gleam/uri.{type Uri}
import lustre
import lustre/attribute.{attribute, class, href, rel, src, target}
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html.{
  a, aside, br, div, h1, h2, img, li, nav, p, section, span, text, ul,
}
import modem

// FFI

@external(javascript, "./app.ffi.mjs", "setDocumentTitle")
fn set_document_title(title: String) -> Nil

// Route

type Route {
  Home
  CodeOfConduct
  NotFound
}

fn parse_route(uri: Uri) -> Route {
  case uri.path_segments(uri.path) {
    [] | [""] -> Home
    ["code-of-conduct"] -> CodeOfConduct
    _ -> NotFound
  }
}

fn get_page_title(route: Route) -> String {
  case route {
    Home -> "関数型まつり 2026"
    CodeOfConduct -> "行動規範 - 関数型まつり 2026"
    NotFound -> "404 - 関数型まつり 2026"
  }
}

// Model

type Model {
  Model(route: Route)
}

fn init(_flags) -> #(Model, Effect(Msg)) {
  #(Model(route: Home), modem.init(on_url_change))
}

// Update

type Msg {
  OnRouteChange(Route)
}

fn on_url_change(uri: Uri) -> Msg {
  OnRouteChange(parse_route(uri))
}

fn handle_route_change(route: Route) -> Effect(Msg) {
  effect.from(fn(_) { set_document_title(get_page_title(route)) })
}

fn update(_model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    OnRouteChange(route) -> #(Model(route: route), handle_route_change(route))
  }
}

// View

fn view(model: Model) -> Element(Msg) {
  div([class("min-h-screen flex flex-col")], [
    navbar(),
    case model.route {
      Home -> home_content()
      CodeOfConduct -> code_of_conduct.page()
      NotFound -> not_found_page()
    },
    footer(),
  ])
}

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

// Components

fn navbar() -> Element(Msg) {
  div([class("navbar bg-base-100 px-4")], [
    div([class("navbar-start")], [
      a([href("/"), class("btn btn-ghost text-xl")], [text("関数型まつり 2026")]),
    ]),
    div([class("navbar-center hidden md:flex")], [
      ul([class("menu menu-horizontal px-1")], [
        li([], [
          a([href("/code-of-conduct"), class("link link-hover")], [text("行動規範")]),
        ]),
      ]),
    ]),
    div([class("navbar-end")], [
      social_link_group([
        SocialLinkConfig(
          label: "Follow us on X",
          url: "https://x.com/fp_matsuri",
          icon: "/icons/x.svg",
        ),
        SocialLinkConfig(
          label: "Bluesky",
          url: "https://bsky.app/profile/fp-matsuri.bsky.social",
          icon: "/icons/bluesky.svg",
        ),
        SocialLinkConfig(
          label: "関数型まつり運営ブログ",
          url: "https://blog.fp-matsuri.org/",
          icon: "/icons/hatenablog.svg",
        ),
      ]),
    ]),
  ])
}

fn home_content() -> Element(Msg) {
  div([], [hero_section(), about_section()])
}

fn hero_section() -> Element(Msg) {
  div([class("hero flex-1 py-20 relative overflow-hidden")], [
    cloud.cloud_decorations(),
    div([class("hero-content text-center relative z-10")], [
      div([class("max-w-md")], [
        img([
          src("/image/logomark.svg"),
          attribute("alt", "関数型まつり"),
          class("w-32 mx-auto mb-6"),
        ]),
        img([
          src("/image/logotype.svg"),
          attribute("alt", "関数型まつり"),
          class("w-64 mx-auto mb-16"),
        ]),
        event_info(date: "2026年7月11日(土), 12日(日)", venue: "中野セントラルパーク カンファレンス"),
      ]),
    ]),
  ])
}

fn event_info(date date: String, venue venue: String) -> Element(Msg) {
  div([], [
    div([class("mb-4")], [
      span([class("badge badge-lg badge-primary")], [text("開催決定")]),
    ]),
    p([class("text-lg mb-2")], [text(date)]),
    p([], [text(venue)]),
  ])
}

type SocialLinkConfig {
  SocialLinkConfig(label: String, url: String, icon: String)
}

fn social_link(config: SocialLinkConfig) -> Element(Msg) {
  a(
    [
      href(config.url),
      target("_blank"),
      rel("noopener noreferrer"),
      attribute("aria-label", config.label),
      class("btn btn-ghost btn-circle border-none hover:bg-base-300"),
    ],
    [
      img([
        src(config.icon),
        attribute("alt", config.label),
        class("w-6 h-6"),
      ]),
    ],
  )
}

fn social_link_group(configs: List(SocialLinkConfig)) -> Element(Msg) {
  nav(
    [class("grid grid-flow-col gap-1 justify-center")],
    list.map(configs, social_link),
  )
}

fn about_section() -> Element(Msg) {
  section([class("py-16 px-4 bg-base-100")], [
    div([class("max-w-2xl mx-auto")], [
      div([class("card bg-neutral text-neutral-content")], [
        div([class("card-body")], [
          h2([class("card-title text-xl mb-8 justify-center")], [
            text("関数型プログラミングのカンファレンス"),
            br([]),
            text("「関数型まつり 2026」を開催します！"),
          ]),
          p([class("mb-4 text-base")], [
            text(
              "昨年の「関数型まつり」では、参加者総数494名、登壇者48名による多様なセッションを実施し、言語コミュニティの垣根を越えた交流と学びが生まれました。
              好評をいただき、今年も「関数型まつり 2026」を開催します！",
            ),
          ]),
          ul([class("text-base")], [
            li([], [text("日時：2026年7月11日(土), 12日(日)")]),
            li([], [text("会場：中野セントラルパーク カンファレンス")]),
          ]),
          div([class("divider")], []),
          p([class("mb-4 text-base")], [
            text(
              "関数型プログラミングはメジャーな言語・フレームワークに取り入れられ、広く使われるようになりました。
そしてその手法自体も進化し続けています。
その一方で「関数型プログラミング」というと「難しい・とっつきにくい」という声もあり、十分普及し切った状態ではありません。",
            ),
          ]),
          p([class("text-base")], [
            text(
              "私たちは様々な背景の方々が関数型プログラミングを通じて新しい知見を得て、交流ができるような場を提供することを目指しています。
普段から関数型言語を活用している方や関数型プログラミングに興味がある方はもちろん、最先端のソフトウェア開発技術に興味がある方もぜひご参加ください！",
            ),
          ]),
        ]),
      ]),
    ]),
  ])
}

fn not_found_page() -> Element(Msg) {
  div([class("flex-1 flex items-center justify-center py-20")], [
    div([class("text-center")], [
      h1([class("text-6xl font-bold mb-4")], [text("404")]),
      p([class("text-xl mb-8")], [text("ページが見つかりません")]),
      a([href("/"), class("btn btn-primary")], [text("ホームに戻る")]),
    ]),
  ])
}

fn footer() -> Element(Msg) {
  html.footer(
    [
      class(
        "footer footer-horizontal footer-center p-10 bg-base-200 text-base-content",
      ),
    ],
    [
      nav([class("grid grid-flow-col gap-4")], [
        a([href("/code-of-conduct"), class("link link-hover")], [
          text("行動規範"),
        ]),
        a(
          [
            href("https://forms.gle/nwG9RnkP3AHWQtzh6"),
            target("_blank"),
            rel("noopener noreferrer"),
            class("link link-hover"),
          ],
          [text("お問い合わせ")],
        ),
        a(
          [
            href("https://www.ttrinity.jp/shop/fp-matsuri/"),
            target("_blank"),
            rel("noopener noreferrer"),
            class("link link-hover"),
          ],
          [text("公式オンラインストア")],
        ),
        a(
          [
            href("https://2025.fp-matsuri.org/"),
            target("_blank"),
            rel("noopener noreferrer"),
            class("link link-hover"),
          ],
          [text("関数型まつり2025")],
        ),
      ]),
      social_link_group([
        SocialLinkConfig(
          label: "X",
          url: "https://x.com/fp_matsuri",
          icon: "/icons/x.svg",
        ),
        SocialLinkConfig(
          label: "Bluesky",
          url: "https://bsky.app/profile/fp-matsuri.bsky.social",
          icon: "/icons/bluesky.svg",
        ),
        SocialLinkConfig(
          label: "関数型まつり運営ブログ",
          url: "https://blog.fp-matsuri.org/",
          icon: "/icons/hatenablog.svg",
        ),
      ]),
      aside([], [
        p([class("text-sm")], [text("© 2026 関数型まつり準備委員会")]),
      ]),
    ],
  )
}
