import gleam/list
import gleam/string
import lustre/attribute.{attribute, class, href, rel, src, target}
import lustre/element.{type Element}
import lustre/element/html.{a, aside, div, h3, img, nav, p, text}

pub fn footer() -> Element(msg) {
  html.footer(
    [
      class(
        "py-12 px-6 flex flex-col items-center gap-10 bg-base-300 text-base-content",
      ),
    ],
    [
      div([class("footer sm:footer-horizontal max-w-2xl")], [
        nav([], [
          h3([class("footer-title")], [
            text("関数型まつり2026"),
          ]),
          nav_link(label: "行動規範", url: "/code-of-conduct/"),
          nav_link(label: "お問い合わせ", url: "https://forms.gle/nwG9RnkP3AHWQtzh6"),
          nav_link(
            label: "公式オンラインストア",
            url: "https://www.ttrinity.jp/shop/fp-matsuri/",
          ),
        ]),
        nav([], [
          h3([class("footer-title")], [text("過去の開催")]),
          nav_link(label: "関数型まつり2025", url: "https://2025.fp-matsuri.org/"),
        ]),
        nav(
          [
            class(
              "w-full grid grid-flow-col gap-1 justify-center sm:justify-start",
            ),
          ],
          [
            social_link(
              label: "X",
              url: "https://x.com/fp_matsuri",
              icon: "/icons/x.svg",
            ),
            social_link(
              label: "Bluesky",
              url: "https://bsky.app/profile/fp-matsuri.bsky.social",
              icon: "/icons/bluesky.svg",
            ),
            social_link(
              label: "関数型まつり運営ブログ",
              url: "https://blog.fp-matsuri.org/",
              icon: "/icons/hatenablog.svg",
            ),
          ],
        ),
      ]),
      aside([], [
        p([class("text-sm")], [text("© 2026 関数型まつり準備委員会")]),
      ]),
    ],
  )
}

fn social_link(
  label label: String,
  url url: String,
  icon icon: String,
) -> Element(msg) {
  a(
    [
      href(url),
      target("_blank"),
      rel("noopener noreferrer"),
      attribute("aria-label", label),
      class("btn btn-ghost btn-circle border-none hover:bg-base-300"),
    ],
    [
      img([
        src(icon),
        attribute("alt", label),
        class("w-6 h-6"),
      ]),
    ],
  )
}

fn is_external_link(url: String) -> Bool {
  string.starts_with(url, "http://") || string.starts_with(url, "https://")
}

fn nav_link(label label: String, url url: String) -> Element(msg) {
  let base_attrs = [href(url), class("link link-hover")]
  let attrs = case is_external_link(url) {
    True ->
      list.append(base_attrs, [target("_blank"), rel("noopener noreferrer")])
    False -> base_attrs
  }
  a(attrs, [text(label)])
}
