import components/button
import gleam/list
import layout.{type Page, Page}
import lustre/attribute.{attribute, class, src}
import lustre/element.{type Element}
import lustre/element/html.{a, div, h1, h2, h3, img, p, section, text}
import sponsor.{type Sponsor}

pub fn page() -> Page(msg) {
  let sponsors = sponsor.load_all()

  Page(title: "スポンサー | 関数型まつり2026", body: [
    page_header(),
    sponsor_plan_section(
      title: "プラチナスポンサー",
      sponsors: sponsors(sponsor.Platinum),
    ),
    sponsor_plan_section(title: "ゴールドスポンサー", sponsors: sponsors(sponsor.Gold)),
    sponsor_plan_section(title: "シルバースポンサー", sponsors: sponsors(sponsor.Silver)),
    logo_plan_section(sponsors(sponsor.Logo)),
    recruitment_section(),
  ])
}

fn page_header() -> Element(msg) {
  section([class("pt-16 pb-8 px-4 bg-base-100")], [
    div([class("max-w-3xl mx-auto text-center")], [
      h1([class("text-3xl font-bold mb-4 tracking-tight")], [
        text("スポンサー"),
      ]),
      p([class("text-base leading-relaxed")], [
        text("関数型まつり2026を支えてくださるスポンサーの皆様をご紹介します。"),
      ]),
    ]),
  ])
}

fn sponsor_plan_section(
  title title: String,
  sponsors sponsors: List(Sponsor),
) -> Element(msg) {
  section([class("py-8 px-4 bg-base-100")], [
    div([class("max-w-3xl mx-auto")], [
      h2([class("text-xl font-bold mb-6 text-center tracking-tight")], [
        text(title),
      ]),
      div([class("space-y-6")], list.map(sponsors, sponsor_card)),
    ]),
  ])
}

fn sponsor_card(s: Sponsor) -> Element(msg) {
  div(
    [
      class(
        "card bg-neutral text-neutral-content border border-subtle shadow-none",
      ),
    ],
    [
      div([class("card-body p-6 md:p-8")], [
        div([class("flex flex-col sm:flex-row gap-6 items-start")], [
          sponsor_logo(s),
          div([class("flex-1")], [
            sponsor_name_link(s),
            ..sponsor_description(s)
          ]),
        ]),
      ]),
    ],
  )
}

fn sponsor_logo(s: Sponsor) -> Element(msg) {
  img([
    src(s.image),
    attribute("alt", s.name),
    class(
      "w-full sm:w-48 md:w-56 h-auto aspect-[21/9] object-contain bg-white rounded-lg shrink-0",
    ),
  ])
}

fn sponsor_name_link(s: Sponsor) -> Element(msg) {
  case s.href {
    "" -> h3([class("text-lg font-bold")], [text(s.name)])
    href ->
      a(
        [
          attribute("href", href),
          attribute("target", "_blank"),
          attribute("rel", "noopener noreferrer"),
          class("link link-hover"),
        ],
        [h3([class("text-lg font-bold")], [text(s.name)])],
      )
  }
}

fn sponsor_description(s: Sponsor) -> List(Element(msg)) {
  case s.description {
    "" -> []
    description -> [
      element.unsafe_raw_html(
        "",
        "div",
        [
          class(
            "prose prose-sm max-w-none mt-3
            prose-headings:font-bold prose-headings:text-neutral-content
            prose-p:leading-relaxed prose-p:text-neutral-content
            prose-a:text-primary
            prose-ul:list-disc prose-ul:pl-6 prose-ul:text-neutral-content
            prose-li:text-neutral-content
            prose-strong:text-neutral-content",
          ),
        ],
        description,
      ),
    ]
  }
}

fn logo_plan_section(sponsors: List(Sponsor)) -> Element(msg) {
  section([class("py-8 px-4 bg-base-100")], [
    div([class("max-w-3xl mx-auto")], [
      h2([class("text-xl font-bold mb-6 text-center tracking-tight")], [
        text("ロゴスポンサー"),
      ]),
      div(
        [
          class(
            "grid grid-cols-[repeat(3,96px)] sm:grid-cols-[repeat(4,128px)] gap-2 justify-center",
          ),
        ],
        list.map(sponsors, logo_sponsor_item),
      ),
    ]),
  ])
}

fn logo_sponsor_item(s: Sponsor) -> Element(msg) {
  let img_element =
    img([
      src(s.image),
      attribute("alt", s.name),
      class(
        "w-full h-auto aspect-[21/9] object-contain bg-white rounded-lg shadow-sm",
      ),
    ])

  case s.href {
    "" -> div([], [img_element])
    href ->
      a(
        [
          attribute("href", href),
          attribute("target", "_blank"),
          attribute("rel", "noopener noreferrer"),
        ],
        [img_element],
      )
  }
}

fn recruitment_section() -> Element(msg) {
  section([class("py-16 px-4 bg-base-200")], [
    div([class("max-w-3xl mx-auto")], [
      h2([class("text-2xl font-bold text-center mb-8 tracking-tight")], [
        text("スポンサー募集"),
      ]),
      div(
        [
          class(
            "card bg-neutral text-neutral-content border border-subtle shadow-none",
          ),
        ],
        [
          div([class("card-body p-8 md:p-10")], [
            p([class("text-base mb-2 leading-relaxed")], [
              text(
                "関数型まつり2026 のスポンサーを募集しています。関数型プログラミングのコミュニティを一緒に盛り上げてくださる企業・団体の皆様をお待ちしております。",
              ),
            ]),
            p([class("text-base mb-6 leading-relaxed")], [
              text("詳細なスポンサープランや特典内容については、スポンサー向け資料をご確認ください。"),
            ]),
            div([class("card-actions justify-center")], [
              button.primary(
                label: "スポンサーシップのご案内",
                url: "https://docs.google.com/presentation/d/18gdlsPhTKK_95xIqKYOzBCehAiPOaIxNaSC92mV09_U/",
              ),
            ]),
          ]),
        ],
      ),
    ]),
  ])
}
