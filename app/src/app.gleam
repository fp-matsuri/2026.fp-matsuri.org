import cloud
import gleam/list
import lustre
import lustre/attribute.{attribute, class, href, rel, src, target}
import lustre/element.{type Element}
import lustre/element/html.{
  a, aside, br, div, h2, img, li, nav, p, section, span, text, ul,
}

pub fn main() {
  let app =
    lustre.element(
      div([class("min-h-screen flex flex-col")], [
        navbar(),
        hero_section(),
        about_section(),
        footer(),
      ]),
    )
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

// View

fn navbar() -> Element(a) {
  div([class("navbar bg-base-100 px-4")], [
    div([class("navbar-start")], []),
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

fn hero_section() -> Element(a) {
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

fn event_info(date date: String, venue venue: String) -> Element(a) {
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

fn social_link(config: SocialLinkConfig) -> Element(a) {
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

fn social_link_group(configs: List(SocialLinkConfig)) -> Element(a) {
  nav(
    [class("grid grid-flow-col gap-1 justify-center")],
    list.map(configs, social_link),
  )
}

fn about_section() -> Element(a) {
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

fn footer() -> Element(a) {
  html.footer(
    [
      class(
        "footer footer-horizontal footer-center p-10 bg-base-200 text-base-content",
      ),
    ],
    [
      navigation_link_group([
        NavigationLinkConfig(
          label: "お問い合わせ",
          url: "https://forms.gle/nwG9RnkP3AHWQtzh6",
        ),
        NavigationLinkConfig(
          label: "公式オンラインストア",
          url: "https://www.ttrinity.jp/shop/fp-matsuri/",
        ),
        NavigationLinkConfig(
          label: "関数型まつり2025",
          url: "https://2025.fp-matsuri.org/",
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

type NavigationLinkConfig {
  NavigationLinkConfig(label: String, url: String)
}

fn navigation_link(config: NavigationLinkConfig) -> Element(a) {
  a(
    [
      href(config.url),
      target("_blank"),
      rel("noopener noreferrer"),
      class("link link-hover"),
    ],
    [text(config.label)],
  )
}

fn navigation_link_group(configs: List(NavigationLinkConfig)) -> Element(a) {
  nav([class("grid grid-flow-col gap-4")], list.map(configs, navigation_link))
}
