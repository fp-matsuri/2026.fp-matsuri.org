import components/button
import gleam/list
import gleam/option.{None, Some}
import layout.{type Page, Page}
import lustre/attribute.{attribute, class, src}
import lustre/element.{type Element}
import lustre/element/html.{a, div, h1, img, p, section, span, text}
import session.{type Session, type SessionTag}

pub fn page() -> Page(msg) {
  let sessions = session.load_sessions()

  Page(title: "セッション一覧 | 関数型まつり2026", body: [
    page_header(),
    sessions_section(sessions),
  ])
}

fn page_header() -> Element(msg) {
  section([class("pt-16 pb-8 px-4 bg-base-100")], [
    div([class("max-w-4xl mx-auto text-center")], [
      h1([class("text-3xl font-bold mb-4 tracking-tight")], [
        text("セッション一覧"),
      ]),
      p([class("text-base leading-relaxed max-w-2xl mx-auto")], [
        text("時刻・トラック情報は今後反映予定です。"),
      ]),
      div(
        [
          class(
            "mt-6 flex flex-col sm:flex-row gap-3 justify-center items-center",
          ),
        ],
        [
          button.primary(
            label: "fortee で詳細を見る",
            url: "https://fortee.jp/2026fp-matsuri",
          ),
        ],
      ),
    ]),
  ])
}

fn sessions_section(sessions: Result(List(Session), String)) -> Element(msg) {
  section([class("pb-20 px-4 bg-base-100")], [
    div([class("max-w-4xl mx-auto")], [
      case sessions {
        Ok([]) -> empty_state()
        Ok(items) -> div([class("space-y-6")], list.map(items, session_card))
        Error(_) -> error_state()
      },
    ]),
  ])
}

fn empty_state() -> Element(msg) {
  div([class("card bg-base-200 border border-subtle shadow-none")], [
    div([class("card-body p-8 text-center")], [
      p([class("text-base leading-relaxed")], [
        text("現在表示できるセッションはありません。"),
      ]),
    ]),
  ])
}

fn error_state() -> Element(msg) {
  div([class("card bg-base-200 border border-subtle shadow-none")], [
    div([class("card-body p-8 text-center")], [
      p([class("text-base leading-relaxed")], [
        text("セッション情報を読み込めませんでした。最新情報は fortee をご確認ください。"),
      ]),
      div([class("mt-4")], [
        button.primary(
          label: "fortee を開く",
          url: "https://fortee.jp/2026fp-matsuri",
        ),
      ]),
    ]),
  ])
}

fn session_card(item: Session) -> Element(msg) {
  a(
    [
      attribute("href", item.url),
      attribute("target", "_blank"),
      attribute("rel", "noopener noreferrer"),
      class(
        "card bg-neutral text-neutral-content border border-subtle shadow-none no-underline transition-colors hover:bg-base-200/40",
      ),
    ],
    [
      div([class("card-body p-6 md:p-8 gap-5")], [
        div([class("flex flex-col gap-3")], [
          div(
            [class("flex flex-wrap items-center gap-2")],
            list.map(item.tags, session_tag),
          ),
          p([class("text-xl font-bold leading-tight")], [text(item.title)]),
        ]),
        speaker_block(item),
      ]),
    ],
  )
}

fn speaker_block(item: Session) -> Element(msg) {
  let speaker = item.speaker

  div([class("flex items-center gap-4")], [
    case speaker.avatar_url {
      Some(url) ->
        img([
          src(url),
          attribute("alt", speaker.name),
          class("w-14 h-14 rounded-full object-cover border border-black/5"),
        ])
      None -> div([class("w-14 h-14 rounded-full bg-base-200 shrink-0")], [])
    },
    div([class("flex flex-col gap-1")], [
      p([class("text-base font-semibold leading-none")], [text(speaker.name)]),
      case speaker.kana {
        "" -> text("")
        kana -> p([class("text-sm text-secondary leading-none")], [text(kana)])
      },
    ]),
  ])
}

fn session_tag(tag: SessionTag) -> Element(msg) {
  span([class("badge badge-outline border-base-content/20 text-base-content")], [
    text(tag.name),
  ])
}
