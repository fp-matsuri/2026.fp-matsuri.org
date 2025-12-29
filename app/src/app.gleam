import lustre
import lustre/attribute.{attribute, class, href, rel, src, target}
import lustre/element.{type Element}
import lustre/element/html.{a, br, div, h1, img, p, text}

pub fn main() {
  let app =
    lustre.element(
      div([class("hero min-h-screen")], [
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
                label: "Follow us on X (Twitter)",
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
            p([class("text-xs mt-4 opacity-70")], [text("SNSや運営ブログから続報を発信します！")]),
            div([class("divider")], []),
            simple_link(SimpleLinkConfig(
              label: "お問い合わせ",
              url: "https://forms.gle/nwG9RnkP3AHWQtzh6",
            )),
            p([class("text-xs mt-4 opacity-70")], [
              text("関数型まつりに関するお問い合わせはこちらからお願いいたします"),
            ]),
          ]),
        ]),
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

type SimpleLinkConfig {
  SimpleLinkConfig(label: String, url: String)
}

fn simple_link(config: SimpleLinkConfig) -> Element(a) {
  a(
    [
      href(config.url),
      target("_blank"),
      rel("noopener noreferrer"),
      class("btn btn-outline shadow-none"),
    ],
    [text(config.label)],
  )
}
