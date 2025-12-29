import gleam/list
import lustre
import lustre/attribute.{attribute, class, href, rel, src, target}
import lustre/element.{type Element}
import lustre/element/html.{a, aside, div, img, nav, p, text}

pub fn main() {
  let app =
    lustre.element(
      div([class("min-h-screen flex flex-col")], [
        div([class("hero flex-1")], [
          div([class("hero-content text-center")], [
            div([class("max-w-md")], [
              img([
                src("/image/logomark.svg"),
                attribute("alt", "関数型まつり"),
                class("w-24 mx-auto mb-6"),
              ]),
              img([
                src("/image/logotype.svg"),
                attribute("alt", "関数型まつり"),
                class("w-64 mx-auto mb-8"),
              ]),
              div([class("mb-8")], [
                p([class("text-xl mb-2")], [
                  text("2026年7月11日（土）・12日（日）"),
                ]),
                p([class("text-sm opacity-90")], [
                  text("中野セントラルパーク カンファレンス"),
                ]),
              ]),
              div([class("flex flex-col gap-3")], [
                external_link(ExternalLinkConfig(
                  label: "Follow us on X",
                  url: "https://x.com/fp_matsuri",
                  icon: "/icons/x.svg",
                )),
                external_link(ExternalLinkConfig(
                  label: "Bluesky",
                  url: "https://bsky.app/profile/fp-matsuri.bsky.social",
                  icon: "/icons/bluesky.svg",
                )),
                external_link(ExternalLinkConfig(
                  label: "関数型まつり運営ブログ",
                  url: "https://blog.fp-matsuri.org/",
                  icon: "/icons/hatenablog.svg",
                )),
              ]),
              p([class("text-xs mt-4 opacity-70")], [
                text("SNSや運営ブログから続報を発信します！"),
              ]),
            ]),
          ]),
        ]),
        footer(),
      ]),
    )
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

// View

type ExternalLinkConfig {
  ExternalLinkConfig(label: String, url: String, icon: String)
}

fn external_link(config: ExternalLinkConfig) -> Element(a) {
  a(
    [
      href(config.url),
      target("_blank"),
      rel("noopener noreferrer"),
      class("btn btn-primary shadow-none"),
    ],
    [
      img([
        src(config.icon),
        attribute("alt", ""),
        class("w-5 h-5 inline-block mr-2"),
      ]),
      text(config.label),
    ],
  )
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
          label: "X (Twitter)",
          url: "https://x.com/fp_matsuri",
          icon: "/icons/x_dark.svg",
        ),
        SocialLinkConfig(
          label: "Bluesky",
          url: "https://bsky.app/profile/fp-matsuri.bsky.social",
          icon: "/icons/bluesky_dark.svg",
        ),
        SocialLinkConfig(
          label: "関数型まつり運営ブログ",
          url: "https://blog.fp-matsuri.org/",
          icon: "/icons/hatenablog_dark.svg",
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
  nav([class("grid grid-flow-col gap-4")], list.map(configs, social_link))
}
