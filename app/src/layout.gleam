import gleam/list
import gleam/string
import lustre/attribute.{attribute, class, href, rel, src, target}
import lustre/element.{type Element}
import lustre/element/html.{
  a, aside, body, div, head, html, img, link, meta, nav, p, text,
}

// Site metadata constants
const site_name = "関数型まつり 2026"

const site_description = "関数型まつりは関数型プログラミングをテーマとしたカンファレンスです"

const site_url = "https://2026.fp-matsuri.org"

const site_image = "https://2026.fp-matsuri.org/summaryLarge.png"

pub fn spa_frame(content: Element(Nil)) -> Element(Nil) {
  html([attribute("lang", "ja")], [
    head([], [
      meta([attribute("charset", "UTF-8")]),
      meta([
        attribute("name", "viewport"),
        attribute("content", "width=device-width, initial-scale=1.0"),
      ]),
      // Favicon
      link([
        attribute("rel", "icon"),
        attribute("href", "/favicon.ico"),
        attribute("sizes", "32x32"),
      ]),
      link([
        attribute("rel", "icon"),
        attribute("href", "/icon.svg"),
        attribute("type", "image/svg+xml"),
      ]),
      // Google Fonts - Noto Sans JP
      link([
        attribute("rel", "preconnect"),
        attribute("href", "https://fonts.googleapis.com"),
      ]),
      link([
        attribute("rel", "preconnect"),
        attribute("href", "https://fonts.gstatic.com"),
        attribute("crossorigin", ""),
      ]),
      link([
        attribute("rel", "stylesheet"),
        attribute(
          "href",
          "https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700&display=swap",
        ),
      ]),
      // CSS
      link([
        attribute("rel", "stylesheet"),
        attribute("href", "/src/app.css"),
      ]),
      // General meta tags
      meta([
        attribute("name", "keywords"),
        attribute("content", "関数型プログラミング,FP,関数型まつり,カンファレンス,技術イベント"),
      ]),
    ]),
    body([], [
      div([class("min-h-screen flex flex-col")], [
        navbar(),
        content,
        footer(),
      ]),
    ]),
  ])
}

pub fn page_head(title page_title: String) -> Element(msg) {
  div([class("hidden")], [
    html.title([], page_title),
    meta([
      attribute("name", "description"),
      attribute("content", site_description),
    ]),
    // Open Graph / Facebook
    meta([attribute("property", "og:type"), attribute("content", "website")]),
    meta([
      attribute("property", "og:title"),
      attribute("content", page_title),
    ]),
    meta([
      attribute("property", "og:description"),
      attribute("content", site_description),
    ]),
    meta([
      attribute("property", "og:url"),
      attribute("content", site_url),
    ]),
    meta([
      attribute("property", "og:site_name"),
      attribute("content", site_name),
    ]),
    meta([
      attribute("property", "og:image"),
      attribute("content", site_image),
    ]),
    meta([attribute("property", "og:locale"), attribute("content", "ja_JP")]),
    // Twitter Cards
    meta([
      attribute("name", "twitter:card"),
      attribute("content", "summary_large_image"),
    ]),
    meta([
      attribute("name", "twitter:title"),
      attribute("content", page_title),
    ]),
    meta([
      attribute("name", "twitter:description"),
      attribute("content", site_description),
    ]),
    meta([
      attribute("name", "twitter:image"),
      attribute("content", site_image),
    ]),
  ])
}

fn navbar() -> Element(msg) {
  div([class("navbar bg-base-100 px-4")], [
    div([class("navbar-start")], [
      a([href("/")], [
        img([
          src("/image/logo_horizontal.svg"),
          attribute("alt", "関数型まつり"),
          class("w-[150px]"),
        ]),
      ]),
    ]),
    div([class("navbar-end gap-1")], [
      social_link(
        label: "Follow us on X",
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
    ]),
  ])
}

fn footer() -> Element(msg) {
  html.footer(
    [
      class(
        "py-12 px-6 flex flex-col items-center gap-10 bg-base-300 text-base-content",
      ),
    ],
    [
      div([class("footer sm:footer-horizontal max-w-2xl")], [
        nav([], [
          html.h3([class("footer-title")], [
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
          html.h3([class("footer-title")], [text("過去の開催")]),
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

fn nav_link(label label: String, url url: String) -> Element(msg) {
  let base_attrs = [href(url), class("link link-hover")]
  let attrs = case is_external_link(url) {
    True ->
      list.append(base_attrs, [target("_blank"), rel("noopener noreferrer")])
    False -> base_attrs
  }
  a(attrs, [text(label)])
}

fn is_external_link(url: String) -> Bool {
  string.starts_with(url, "http://") || string.starts_with(url, "https://")
}
