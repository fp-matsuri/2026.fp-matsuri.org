import components/footer
import components/navbar
import lustre/attribute.{attribute, class}
import lustre/element.{type Element}
import lustre/element/html.{body, div, head, html, link, meta}

pub fn page(page_title: String, content: Element(msg)) -> Element(msg) {
  html([attribute("lang", "ja")], [
    head([], [
      meta([attribute("charset", "UTF-8")]),
      meta([
        attribute("name", "viewport"),
        attribute("content", "width=device-width, initial-scale=1.0"),
      ]),
      html.title([], page_title),
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
        attribute("href", "/assets/app.css"),
      ]),
      // Open Graph / Facebook
      meta([attribute("property", "og:type"), attribute("content", "website")]),
      meta([
        attribute("property", "og:title"),
        attribute("content", "関数型まつり 2026"),
      ]),
      meta([
        attribute("property", "og:description"),
        attribute("content", "関数型まつりは関数型プログラミングをテーマとしたカンファレンスです"),
      ]),
      meta([
        attribute("property", "og:url"),
        attribute("content", "https://2026.fp-matsuri.org"),
      ]),
      meta([
        attribute("property", "og:site_name"),
        attribute("content", "関数型まつり 2026"),
      ]),
      meta([
        attribute("property", "og:image"),
        attribute("content", "https://2026.fp-matsuri.org/summaryLarge.png"),
      ]),
      meta([attribute("property", "og:locale"), attribute("content", "ja_JP")]),
      // Twitter Cards
      meta([
        attribute("name", "twitter:card"),
        attribute("content", "summary_large_image"),
      ]),
      meta([
        attribute("name", "twitter:title"),
        attribute("content", "関数型まつり 2026"),
      ]),
      meta([
        attribute("name", "twitter:description"),
        attribute("content", "関数型まつりは関数型プログラミングをテーマとしたカンファレンスです"),
      ]),
      meta([
        attribute("name", "twitter:image"),
        attribute("content", "https://2026.fp-matsuri.org/summaryLarge.png"),
      ]),
      // General meta tags
      meta([
        attribute("name", "description"),
        attribute("content", "関数型まつりは関数型プログラミングをテーマとしたカンファレンスです"),
      ]),
      meta([
        attribute("name", "keywords"),
        attribute("content", "関数型プログラミング,FP,関数型まつり,カンファレンス,技術イベント"),
      ]),
    ]),
    body([], [
      div([class("min-h-screen flex flex-col")], [
        navbar.navbar(),
        content,
        footer.footer(),
      ]),
    ]),
  ])
}
