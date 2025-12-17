import lustre
import lustre/attribute.{attribute, class}
import lustre/element/html.{a, button, div, footer, h1, h2, h3, p, text}

pub fn main() {
  let app =
    lustre.element(
      div([class("min-h-screen bg-base-100")], [
        // Hero section - Main content
        div([class("hero min-h-screen")], [
          div([class("hero-content text-center")], [
            div([class("max-w-2xl")], [
              // Logo placeholder - replace with actual logo later
              div([class("mb-8")], [
                h1([class("text-6xl font-bold mb-2")], [text("関数型まつり")]),
                div([class("text-4xl font-light text-primary")], [
                  text("Functional Programming Festival"),
                ]),
              ]),

              // Year and Coming Soon
              div([class("mb-12")], [
                h2([class("text-8xl font-bold text-primary mb-4")], [
                  text("2026"),
                ]),
                div([class("badge badge-lg badge-outline badge-primary")], [
                  text("COMING SOON"),
                ]),
              ]),

              // Announcement
              div([class("card bg-base-200 shadow-xl mb-8")], [
                div([class("card-body")], [
                  h3([class("card-title text-2xl justify-center mb-4")], [
                    text("関数型まつり 2026 開催予定！"),
                  ]),
                  p([class("text-lg")], [
                    text("最新情報は SNS にて配信予定です"),
                  ]),
                ]),
              ]),

              // Links section
              div(
                [
                  class(
                    "flex flex-col sm:flex-row gap-4 justify-center items-center",
                  ),
                ],
                [
                  a(
                    [
                      attribute("href", "https://x.com/fp_matsuri"),
                      attribute("target", "_blank"),
                      attribute("rel", "noopener noreferrer"),
                      class("btn btn-primary btn-wide"),
                    ],
                    [
                      text("X (Twitter)"),
                    ],
                  ),
                  a(
                    [
                      attribute("href", "https://fp-matsuri.hatenablog.com/"),
                      attribute("target", "_blank"),
                      attribute("rel", "noopener noreferrer"),
                      class("btn btn-secondary btn-wide"),
                    ],
                    [
                      text("公式ブログ"),
                    ],
                  ),
                  a(
                    [
                      attribute("href", "https://forms.gle/your-form-id"),
                      attribute("target", "_blank"),
                      attribute("rel", "noopener noreferrer"),
                      class("btn btn-outline btn-wide"),
                    ],
                    [
                      text("お問い合わせ"),
                    ],
                  ),
                ],
              ),
            ]),
          ]),
        ]),

        // Footer
        footer(
          [class("footer footer-center p-10 bg-base-200 text-base-content")],
          [
            div([], [
              p([class("font-semibold")], [
                text("関数型まつり実行委員会"),
              ]),
              p([], [
                text(
                  "© 2024-2026 Functional Programming Festival. All rights reserved.",
                ),
              ]),
            ]),
          ],
        ),
      ]),
    )
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}
