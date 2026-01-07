import code_of_conduct_content
import jot
import lustre/attribute.{class}
import lustre/element.{type Element}
import lustre/element/html.{div, h1, section, text}

pub fn page() -> Element(msg) {
  let html_content = jot.to_html(code_of_conduct_content.content)

  section([class("py-16 px-4 bg-base-100 flex-1")], [
    div([class("max-w-3xl mx-auto")], [
      h1([class("text-3xl font-bold mb-12 text-center")], [text("行動規範")]),
      element.unsafe_raw_html(
        "",
        "div",
        [
          class(
            "prose prose-lg max-w-none
            prose-headings:font-bold prose-headings:mb-4
            prose-h2:text-xl prose-h2:mt-10
            prose-p:leading-relaxed prose-p:mb-4
            prose-ul:list-disc prose-ul:pl-6 prose-ul:space-y-2
            prose-a:link prose-a:link-primary
            ",
          ),
        ],
        html_content,
      ),
    ]),
  ])
}
