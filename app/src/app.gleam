import gleam/list
import lustre
import lustre/attribute.{attribute, class, href, rel, src, target}
import lustre/element.{type Element}
import lustre/element/html.{
  a, aside, br, div, h2, img, nav, p, section, span, text,
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
    cloud_decorations(),
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

type CloudConfig {
  CloudConfig(
    src: String,
    position_classes: String,
    size_class: String,
    opacity_class: String,
    animation_class: String,
  )
}

fn cloud_decoration(config: CloudConfig) -> Element(a) {
  img([
    src(config.src),
    attribute("alt", ""),
    attribute("aria-hidden", "true"),
    class(
      "absolute pointer-events-none select-none "
      <> config.position_classes
      <> " "
      <> config.size_class
      <> " "
      <> config.opacity_class
      <> " "
      <> config.animation_class,
    ),
  ])
}

fn cloud_decorations() -> Element(a) {
  let clouds = [
    // 左上
    CloudConfig(
      src: "/image/pattern/cloud_0.svg",
      position_classes: "-top-8 -left-12 md:-top-6 md:-left-8",
      size_class: "w-56 md:w-80",
      opacity_class: "opacity-80",
      animation_class: "animate-float-slow",
    ),
    // 右上
    CloudConfig(
      src: "/image/pattern/cloud_3.svg",
      position_classes: "top-8 -right-16 md:top-12 md:-right-12",
      size_class: "w-52 md:w-72",
      opacity_class: "opacity-60",
      animation_class: "animate-float-medium",
    ),
    // 左下
    CloudConfig(
      src: "/image/pattern/cloud_1.svg",
      position_classes: "bottom-4 -left-16 md:bottom-8 md:-left-12",
      size_class: "w-64 md:w-96",
      opacity_class: "opacity-100",
      animation_class: "animate-float-medium-reverse",
    ),
    // 右下 (md以上で表示)
    CloudConfig(
      src: "/image/pattern/cloud_10.svg",
      position_classes: "hidden md:block -bottom-4 -right-16 md:bottom-0 md:-right-12",
      size_class: "w-56 md:w-80",
      opacity_class: "opacity-100",
      animation_class: "animate-float-medium",
    ),
    // 上端中央やや右 (md以上で表示)
    CloudConfig(
      src: "/image/pattern/cloud_7.svg",
      position_classes: "hidden md:block -top-4 right-1/4",
      size_class: "w-48 md:w-64",
      opacity_class: "opacity-50",
      animation_class: "animate-float-slow-reverse",
    ),
  ]
  div(
    [class("absolute inset-0 z-0 overflow-hidden")],
    list.map(clouds, cloud_decoration),
  )
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
            text("「関数型まつり2026」を開催します！"),
          ]),
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
