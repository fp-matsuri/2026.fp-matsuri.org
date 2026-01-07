import lustre/attribute.{class, href, rel, target}
import lustre/element.{type Element}
import lustre/element/html.{a, div, h1, h2, li, p, section, text, ul}

pub fn page() -> Element(a) {
  section([class("py-16 px-4 bg-base-100 flex-1")], [
    div([class("max-w-3xl mx-auto")], [
      h1([class("text-3xl font-bold mb-12 text-center")], [text("行動規範")]),
      introduction_section(),
      harassment_section(),
      response_section(),
      operation_section(),
      report_section(),
      license_section(),
    ]),
  ])
}

fn introduction_section() -> Element(a) {
  div([class("mb-10")], [
    h2([class("text-xl font-bold mb-4")], [text("はじめに")]),
    p([class("mb-4 leading-relaxed")], [
      text("関数型まつりは、様々な地域やコミュニティから集う技術者に対して開かれたカンファレンスを目指しています。"),
    ]),
    p([class("leading-relaxed")], [
      text(
        "私たちは、多様な背景を持つ全ての人々が互いに敬意を払い、安心して参加できる環境を提供することを重視しています。このカンファレンスでは、参加者全員に対するハラスメント行為を禁止します。",
      ),
    ]),
  ])
}

fn harassment_section() -> Element(a) {
  div([class("mb-10")], [
    h2([class("text-xl font-bold mb-4")], [text("ハラスメント行為")]),
    p([class("mb-4 leading-relaxed")], [
      text(
        "本規範は、カンファレンス参加者へのハラスメント行為を歓迎しないという立場を明確にしています。会場内、関連ソーシャルイベント、SNS上での全てのコミュニケーションにおいて、参加者、発表者、スポンサー、ブース出展者が遵守することを求めています。",
      ),
    ]),
    p([class("mb-4 leading-relaxed")], [
      text("以下の行為をハラスメントとして禁止します:"),
    ]),
    ul([class("list-disc pl-6 space-y-2")], [
      li([], [
        text("ジェンダー、性自認、障がい、容貌、年齢、人種、国籍、宗教について、当人が不快に感じる発言"),
      ]),
      li([], [text("不適切な身体的接触やナンパ行為")]),
      li([], [text("公共の場での性的な画像掲示、発表資料への性的素材使用")]),
      li([], [text("故意の威嚇、ストーキング、つきまとい、無断撮影・録音")]),
      li([], [text("カンファレンス発表やイベントの継続的妨害")]),
      li([], [
        text("ブーススタッフによる性的な服装・コスチュームの着用"),
      ]),
    ]),
  ])
}

fn response_section() -> Element(a) {
  div([class("mb-10")], [
    h2([class("text-xl font-bold mb-4")], [text("対応方針")]),
    p([class("mb-4 leading-relaxed")], [
      text("行動規範に違反した参加者に対しては、以下の対応を行います:"),
    ]),
    ul([class("list-disc pl-6 space-y-2")], [
      li([], [text("注意・警告")]),
      li([], [
        text("警告に従わずハラスメント行為を繰り返す場合や悪質な場合には、発表の中止"),
      ]),
      li([], [text("カンファレンス会場からの退場指示（参加料の払い戻しなし）")]),
    ]),
  ])
}

fn operation_section() -> Element(a) {
  div([class("mb-10")], [
    h2([class("text-xl font-bold mb-4")], [text("運用方法")]),
    ul([class("list-disc pl-6 space-y-2")], [
      li([], [
        text("インシデント報告窓口をオンライン・オフラインで設置します"),
      ]),
      li([], [
        text("全スポンサーに行動規範準拠の同意を確認し、コンテンツ事前チェックを実施します"),
      ]),
      li([], [
        text("全発表者にCFP応募時の同意確認、スライド事前チェックを実施します"),
      ]),
      li([], [
        text("トイレは本人のジェンダーアイデンティティに基づいた利用が可能です"),
      ]),
    ]),
  ])
}

fn report_section() -> Element(a) {
  div([class("mb-10")], [
    h2([class("text-xl font-bold mb-4")], [text("報告窓口")]),
    p([class("mb-6 leading-relaxed")], [
      text("ハラスメントを受けた場合、または目撃した場合は、以下のフォームからご報告ください:"),
    ]),
    div([class("text-center")], [
      a(
        [
          href("https://forms.gle/4NZfofiHZzBcyZjRA"),
          target("_blank"),
          rel("noopener noreferrer"),
          class("btn btn-primary"),
        ],
        [text("ハラスメント報告フォーム")],
      ),
    ]),
  ])
}

fn license_section() -> Element(a) {
  div([class("mb-10")], [
    h2([class("text-xl font-bold mb-4")], [text("ライセンスと帰属")]),
    p([class("text-sm text-base-content/70 leading-relaxed")], [
      text("この行動規範は、"),
      a(
        [
          href("https://scalamatsuri.org/ja/code-of-conduct"),
          target("_blank"),
          rel("noopener noreferrer"),
          class("link"),
        ],
        [text("ScalaMatsuri行動規範")],
      ),
      text("をベースにしており、"),
      a(
        [
          href(
            "https://geekfeminism.wikia.org/wiki/Conference_anti-harassment/Policy",
          ),
          target("_blank"),
          rel("noopener noreferrer"),
          class("link"),
        ],
        [text("Geek Feminism wiki")],
      ),
      text("から派生したものです。"),
    ]),
  ])
}
