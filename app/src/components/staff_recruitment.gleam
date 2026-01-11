import components/button
import gleam/list
import lustre/attribute.{attribute, class, id, src}
import lustre/element.{type Element}
import lustre/element/html.{
  div, h2, h3, img, input, li, p, section, span, text, ul,
}

pub fn staff_recruitment_section() -> Element(msg) {
  section([id("staff"), class("py-20 px-4 md:px-6 bg-base-200")], [
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
