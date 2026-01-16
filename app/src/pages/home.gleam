import cloud
import components/button
import gleam/list
import layout
import lustre/attribute.{attribute, class, id, src}
import lustre/element.{type Element}
import lustre/element/html.{
  br, div, h2, h3, img, input, li, p, section, span, text, ul,
}

pub fn page() -> Element(msg) {
  div([], [
    layout.page_head(title: "関数型まつり 2026"),
    content(),
  ])
}

fn content() -> Element(msg) {
  div([], [
    hero_section(),
    about_section(),
    sponsor_recruitment_section(),
    staff_recruitment_section(),
  ])
}

// Hero Section
fn hero_section() -> Element(msg) {
  div([class("hero flex-1 py-20 relative overflow-hidden")], [
    cloud.cloud_decorations(),
    div([class("hero-content text-center relative z-10")], [
      div([class("max-w-md")], [
        img([
          src("/image/logomark.svg"),
          attribute("alt", "関数型まつり"),
          class("w-32 mx-auto mb-6"),
        ]),
        img([
          src("/image/logotype.svg"),
          attribute("alt", "関数型まつり"),
          class("w-64 mx-auto mb-16"),
        ]),
        event_info(date: "2026年7月11日(土), 12日(日)", venue: "中野セントラルパーク カンファレンス"),
      ]),
    ]),
  ])
}

fn event_info(date date: String, venue venue: String) -> Element(msg) {
  div([], [
    div([class("mb-4")], [
      span([class("badge badge-lg badge-primary")], [text("開催決定")]),
    ]),
    p([class("text-lg mb-2")], [text(date)]),
    p([], [text(venue)]),
  ])
}

// About Section
fn about_section() -> Element(msg) {
  section([class("py-20 px-6 bg-base-100")], [
    div([class("max-w-2xl mx-auto")], [
      div(
        [
          class(
            "card bg-neutral text-neutral-content border border-subtle shadow-none",
          ),
        ],
        [
          div([class("card-body p-8 md:p-10")], [
            h2([class("card-title text-xl md:text-2xl mb-6 justify-center")], [
              text("関数型プログラミングのカンファレンス"),
              br([]),
              text("「関数型まつり 2026」を開催します！"),
            ]),
            p([class("text-base leading-relaxed")], [
              text(
                "昨年の「関数型まつり」では、参加者総数494名、登壇者48名による多様なセッションを実施し、言語コミュニティの垣根を越えた交流と学びが生まれました。
              好評をいただき、今年も「関数型まつり 2026」を開催します！",
              ),
            ]),
            div([class("divider")], []),
            p([class("mb-4 text-base leading-relaxed")], [
              text(
                "関数型プログラミングはメジャーな言語・フレームワークに取り入れられ、広く使われるようになりました。
そしてその手法自体も進化し続けています。
その一方で「関数型プログラミング」というと「難しい・とっつきにくい」という声もあり、十分普及し切った状態ではありません。",
              ),
            ]),
            p([class("text-base leading-relaxed")], [
              text(
                "私たちは様々な背景の方々が関数型プログラミングを通じて新しい知見を得て、交流ができるような場を提供することを目指しています。
普段から関数型言語を活用している方や関数型プログラミングに興味がある方はもちろん、最先端のソフトウェア開発技術に興味がある方もぜひご参加ください！",
              ),
            ]),
          ]),
        ],
      ),
    ]),
  ])
}

// Sponsor Section
fn sponsor_recruitment_section() -> Element(msg) {
  section([id("sponsors"), class("py-20 px-6 bg-base-200")], [
    div([class("max-w-2xl mx-auto")], [
      h2([class("text-2xl font-bold text-center mb-10 tracking-tight")], [
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
                "関数型まつり 2026 のスポンサーを募集しています。関数型プログラミングのコミュニティを一緒に盛り上げてくださる企業・団体の皆様をお待ちしております。",
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

// Staff Recruitment Section
fn staff_recruitment_section() -> Element(msg) {
  section([id("staff"), class("py-20 px-4 md:px-6 bg-base-100")], [
    div([class("max-w-2xl mx-auto")], [
      h2([class("text-2xl font-bold text-center mb-10")], [
        text("運営スタッフ募集"),
      ]),
      div([class("mb-8")], [
        p([class("text-base mb-8 leading-relaxed")], [
          text(
            "関数型まつり 2026 の企画・運営に一緒に取り組んでくださるコアスタッフを募集しています！関数型プログラミングのコミュニティを盛り上げる舞台裏で活躍してみませんか？",
          ),
        ]),
      ]),
      div([class("space-y-2 mb-12")], [
        collapse(icon: "/icons/calendar-check.svg", name: "プログラムチーム", tasks: [
          "セッション公募（CFP）の要項作成・募集・採択",
          "当日のセッションテーブル（タイムテーブル）の作成",
        ]),
        collapse(icon: "/icons/megaphone.svg", name: "PRチーム", tasks: [
          "公式サイトやSNSでの情報発信",
          "コミュニティに向けた広報活動全般",
        ]),
        collapse(icon: "/icons/handshake.svg", name: "スポンサーチーム", tasks: [
          "企業へのスポンサーシップ依頼・コミュニケーション",
          "広告、ノベルティ、当日ブース設営のサポート",
        ]),
        collapse(icon: "/icons/building.svg", name: "会場チーム", tasks: [
          "チケット販売管理",
          "会場手配、設営・撤収計画の策定",
          "音響、記録、配信の準備と当日のオペレーション",
        ]),
      ]),
      div(
        [
          class(
            "card bg-neutral text-neutral-content border border-subtle shadow-none",
          ),
        ],
        [
          div([class("card-body p-8 md:p-10")], [
            h3([class("text-xl font-bold mb-6 text-center")], [
              text("キックオフミーティング"),
            ]),
            div([class("space-y-2 s")], [
              div([class("flex items-center gap-3")], [
                span(
                  [
                    class("text-sm font-medium text-secondary min-w-[2rem]"),
                  ],
                  [text("日時")],
                ),
                p([class("text-base")], [
                  text("2026年1月18日（日）19:00〜21:00"),
                ]),
              ]),
              div([class("flex items-center gap-3")], [
                span(
                  [
                    class("text-sm font-medium text-secondary min-w-[2rem]"),
                  ],
                  [text("形式")],
                ),
                p([class("text-base")], [
                  text("オンライン（Google Meet）"),
                ]),
              ]),
            ]),
            div([class("divider")], []),
            p([class("text-base leading-relaxed mb-4")], [
              text(
                "初めてカンファレンス運営に参加される方も大歓迎です。まずはキックオフミーティングにご参加いただき、雰囲気を感じていただければと思います。",
              ),
            ]),
            div([class("flex justify-center")], [
              button.primary(
                label: "募集ページを見る",
                url: "https://jsa.connpass.com/event/380068/",
              ),
            ]),
          ]),
        ],
      ),
    ]),
  ])
}

fn collapse(
  icon icon: String,
  name name: String,
  tasks tasks: List(String),
) -> Element(msg) {
  div(
    [
      class(
        "collapse collapse-arrow bg-neutral text-neutral-content border border-subtle shadow-none",
      ),
    ],
    [
      input([attribute("type", "checkbox")]),
      div([class("collapse-title text-base font-semibold")], [
        div([class("flex items-center gap-3")], [
          img([
            src(icon),
            attribute("alt", ""),
            class("w-5 h-5"),
          ]),
          text(name),
        ]),
      ]),
      div([class("collapse-content")], [
        ul(
          [
            class(
              "list-disc list-outside ml-5 space-y-2 text-sm leading-relaxed",
            ),
          ],
          list.map(tasks, fn(task) { li([], [text(task)]) }),
        ),
      ]),
    ],
  )
}
