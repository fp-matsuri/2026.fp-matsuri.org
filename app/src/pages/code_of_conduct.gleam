import code_of_conduct_content
import jot
import layout
import lustre/attribute.{class}
import lustre/element.{type Element}
import lustre/element/html.{div, h1, section, text}

pub fn page() -> Element(msg) {
  layout.page("行動規範 | 関数型まつり 2026", content())
}

fn content() -> Element(msg) {
  let html_content = jot.to_html(code_of_conduct_content.content)

  section([class("py-16 px-4 bg-base-100 flex-1")], [
    div([class("max-w-2xl mx-auto")], [
      div([class("card bg-neutral text-neutral-content")], [
        div([class("card-body")], [
          h1([class("text-3xl font-bold mb-8 text-center")], [text("行動規範")]),
          // YouTube動画の埋め込み
          element.unsafe_raw_html(
            "",
            "div",
            [
              class(
                "my-8
                [&>h2]:text-xl [&>h2]:font-bold [&>h2]:mb-4 [&>h2]:text-neutral-content
                [&>div]:flex [&>div]:justify-center
                ",
              ),
            ],
            code_of_conduct_content.video_iframe,
          ),
          // 行動規範コンテンツ
          element.unsafe_raw_html(
            "",
            "div",
            [
              class(
                "prose prose-lg max-w-none
                prose-headings:font-bold prose-headings:mb-4 prose-headings:text-neutral-content
                prose-h2:text-xl prose-h2:mt-10
                prose-p:leading-relaxed prose-p:mb-4 prose-p:text-base prose-p:text-neutral-content
                prose-ul:list-disc prose-ul:pl-6 prose-ul:space-y-2 prose-ul:text-base prose-ul:text-neutral-content
                prose-li:text-neutral-content
                prose-a:no-underline
                prose-strong:text-neutral-content
                [&_p:has(>a[href*='forms.gle'])]:text-center [&_p:has(>a[href*='forms.gle'])]:my-6
                [&_a[href*='forms.gle']]:btn [&_a[href*='forms.gle']]:btn-primary
                ",
              ),
            ],
            html_content,
          ),
        ]),
      ]),
    ]),
  ])
}
