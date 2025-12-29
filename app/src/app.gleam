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
              class("w-24 mx-auto mb-4"),
            ]),
            img([
              src("/image/logotype.svg"),
              attribute("alt", "関数型まつり"),
              class("w-64 mx-auto mb-8"),
            ]),
            div([class("mb-8")], [
              p([class("text-2xl font-semibold mb-2")], [
                text("2026年7月11日（土）・12日（日）"),
              ]),
              p([class("text-md opacity-90")], [
                text("中野セントラルパーク カンファレンス"),
              ]),
            ]),
            div([class("flex flex-col gap-3")], [
              external_link(ExternalLinkConfig(
                label: "Follow us on X (Twitter)",
                url: "https://x.com/fp_matsuri",
                button_class: "btn btn-primary",
              )),
              external_link(ExternalLinkConfig(
                label: "Official Blog",
                url: "https://blog.fp-matsuri.org/",
                button_class: "btn btn-primary",
              )),
            ]),
            p([class("text-xs mt-4 opacity-70")], [text("X や公式ブログから続報を発信します！")]),
            div([class("divider")], []),
            external_link(ExternalLinkConfig(
              label: "お問い合わせ",
              url: "https://forms.gle/nwG9RnkP3AHWQtzh6",
              button_class: "btn btn-outline",
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
  ExternalLinkConfig(label: String, url: String, button_class: String)
}

fn external_link(config: ExternalLinkConfig) -> Element(a) {
  a(
    [
      href(config.url),
      target("_blank"),
      rel("noopener noreferrer"),
      class(config.button_class),
    ],
    [text(config.label)],
  )
}
