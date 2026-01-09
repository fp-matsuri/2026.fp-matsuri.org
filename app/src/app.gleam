import cloud
import code_of_conduct
import components/button
import gleam/list
import gleam/string
import gleam/uri.{type Uri}
import lustre
import lustre/attribute.{attribute, class, href, rel, src, target}
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html.{
  a, aside, br, div, h1, h2, h3, iframe, img, li, nav, p, section, span, text,
  ul,
}
import modem

// MAIN ------------------------------------------------------------------------

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

// MODEL -----------------------------------------------------------------------

type Model {
  Model(route: Route)
}

type Route {
  Home
  CodeOfConduct
  NotFound
}

fn parse_route(uri: Uri) -> Route {
  case uri.path_segments(uri.path) {
    [] | [""] -> Home
    ["code-of-conduct"] -> CodeOfConduct
    _ -> NotFound
  }
}

fn get_page_title(route: Route) -> String {
  case route {
    Home -> "関数型まつり 2026"
    CodeOfConduct -> "行動規範 | 関数型まつり 2026"
    NotFound -> "404 - 関数型まつり 2026"
  }
}

fn init(_flags) -> #(Model, Effect(Msg)) {
  let initial_route = case modem.initial_uri() {
    Ok(uri) -> parse_route(uri)
    Error(_) -> Home
  }
  #(
    Model(route: initial_route),
    effect.batch([
      modem.init(on_url_change),
      handle_route_change(initial_route),
    ]),
  )
}

// UPDATE ----------------------------------------------------------------------

type Msg {
  OnRouteChange(Route)
}

fn on_url_change(uri: Uri) -> Msg {
  OnRouteChange(parse_route(uri))
}

fn update(_model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    OnRouteChange(route) -> #(Model(route: route), handle_route_change(route))
  }
}

fn handle_route_change(route: Route) -> Effect(Msg) {
  effect.from(fn(_) { set_document_title(get_page_title(route)) })
}

// VIEW ------------------------------------------------------------------------

fn view(model: Model) -> Element(msg) {
  div([class("min-h-screen flex flex-col")], [
    navbar(),
    case model.route {
      Home -> home_content()
      CodeOfConduct -> code_of_conduct.page()
      NotFound -> not_found_page()
    },
    footer(),
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
    div([class("navbar-end")], [
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

fn home_content() -> Element(msg) {
  div([], [
    hero_section(),
    about_section(),
    staff_recruitment_section(),
    sponsor_recruitment_section(),
    venue_section(),
  ])
}

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

fn about_section() -> Element(msg) {
  section([class("py-16 px-4 bg-base-100")], [
    div([class("max-w-2xl mx-auto")], [
      div([class("card bg-neutral text-neutral-content")], [
        div([class("card-body")], [
          h2([class("card-title text-xl mb-4 justify-center")], [
            text("関数型プログラミングのカンファレンス"),
            br([]),
            text("「関数型まつり 2026」を開催します！"),
          ]),
          p([class("text-base")], [
            text(
              "昨年の「関数型まつり」では、参加者総数494名、登壇者48名による多様なセッションを実施し、言語コミュニティの垣根を越えた交流と学びが生まれました。
              好評をいただき、今年も「関数型まつり 2026」を開催します！",
            ),
          ]),
          div([class("divider")], []),
          p([class("mb-4 text-base")], [
            text(
              "関数型プログラミングはメジャーな言語・フレームワークに取り入れられ、広く使われるようになりました。
そしてその手法自体も進化し続けています。
その一方で「関数型プログラミング」というと「難しい・とっつきにくい」という声もあり、十分普及し切った状態ではありません。",
            ),
          ]),
          p([class("text-base")], [
            text(
              "私たちは様々な背景の方々が関数型プログラミングを通じて新しい知見を得て、交流ができるような場を提供することを目指しています。
普段から関数型言語を活用している方や関数型プログラミングに興味がある方はもちろん、最先端のソフトウェア開発技術に興味がある方もぜひご参加ください！",
            ),
          ]),
        ]),
      ]),
    ]),
  ])
}

fn staff_recruitment_section() -> Element(msg) {
  section([class("py-16 px-4 bg-base-100")], [
    div([class("max-w-2xl mx-auto")], [
      h2([class("text-2xl font-bold text-center mb-12")], [
        text("運営スタッフ募集"),
      ]),
      div([class("card bg-neutral text-neutral-content")], [
        div([class("card-body")], [
          p([class("text-base mb-6")], [
            text(
              "関数型まつり 2026 の企画・運営に一緒に取り組んでくださるコアスタッフを募集しています！関数型プログラミングのコミュニティを盛り上げる舞台裏で活躍してみませんか？",
            ),
          ]),
          h3([class("text-lg font-semibold mb-4")], [
            text("キックオフミーティング"),
          ]),
          div([class("mb-6")], [
            p([class("text-sm mb-2")], [
              span([class("font-semibold")], [text("日時：")]),
              text("2026年1月18日（日）19:00〜21:00"),
            ]),
            p([class("text-sm mb-4")], [
              span([class("font-semibold")], [text("形式：")]),
              text("オンライン（Google Meet）"),
            ]),
            p([class("text-base")], [
              text(
                "初めてカンファレンス運営に参加される方も大歓迎です。まずはキックオフミーティングにご参加いただき、雰囲気を感じていただければと思います。",
              ),
            ]),
          ]),
          h3([class("text-lg font-semibold mb-4")], [text("募集している役割・チーム")]),
          div([class("space-y-4 mb-6 text-sm")], [
            div([], [
              p([class("font-semibold mb-1")], [text("プログラムチーム")]),
              ul([class("list-disc list-inside ml-4 space-y-1")], [
                li([], [text("セッション公募（CFP）の要項作成・募集・採択")]),
                li([], [text("当日のセッションテーブル（タイムテーブル）の作成")]),
              ]),
            ]),
            div([], [
              p([class("font-semibold mb-1")], [text("PRチーム")]),
              ul([class("list-disc list-inside ml-4 space-y-1")], [
                li([], [text("公式サイトやSNSでの情報発信")]),
                li([], [text("コミュニティに向けた広報活動全般")]),
              ]),
            ]),
            div([], [
              p([class("font-semibold mb-1")], [text("スポンサーチーム")]),
              ul([class("list-disc list-inside ml-4 space-y-1")], [
                li([], [text("企業へのスポンサーシップ依頼・コミュニケーション")]),
                li([], [text("広告、ノベルティ、当日ブース設営のサポート")]),
              ]),
            ]),
            div([], [
              p([class("font-semibold mb-1")], [text("会場チーム")]),
              ul([class("list-disc list-inside ml-4 space-y-1")], [
                li([], [text("チケット販売管理")]),
                li([], [text("会場手配、設営・撤収計画の策定")]),
                li([], [text("音響、記録、配信の準備と当日のオペレーション")]),
              ]),
            ]),
          ]),
          div([class("card-actions justify-center")], [
            button.primary(
              label: "募集ページを見る",
              url: "https://jsa.connpass.com/event/380068/",
            ),
          ]),
        ]),
      ]),
    ]),
  ])
}

fn sponsor_recruitment_section() -> Element(msg) {
  section([class("py-16 px-4 bg-base-100")], [
    div([class("max-w-2xl mx-auto")], [
      h2([class("text-2xl font-bold text-center mb-12")], [
        text("スポンサー募集"),
      ]),
      div([class("card bg-neutral text-neutral-content")], [
        div([class("card-body")], [
          p([class("text-base mb-6")], [
            text(
              "関数型まつり 2026 のスポンサーを募集しています。関数型プログラミングコミュニティの発展を支援してくださる企業・団体の皆様からのご協賛をお待ちしております。",
            ),
          ]),
          h3([class("text-lg font-semibold mb-4")], [text("スポンサーシップの特典")]),
          div([class("space-y-3 mb-6 text-sm")], [
            ul([class("list-disc list-inside space-y-2 ml-4")], [
              li([], [text("公式サイトおよび各種広報物へのロゴ掲載")]),
              li([], [text("会場でのブース出展や配布物の設置（プランによる）")]),
              li([], [text("関数型プログラミングに関心の高い参加者への認知向上")]),
              li([], [
                text("技術コミュニティとの交流機会およびエンジニア採用活動の支援"),
              ]),
            ]),
          ]),
          p([class("text-base mb-6")], [
            text("詳細なスポンサープランや特典内容については、スポンサー向け資料をご確認の上、お問い合わせフォームよりご連絡ください。"),
          ]),
          div([class("card-actions justify-center")], [
            button.primary(
              label: "スポンサーシップのご案内",
              url: "https://docs.google.com/presentation/d/16tjmPFO3poqKBlrBtq7zv5IiZb1ksX05F_R7GqLFrTo/edit?usp=sharing",
            ),
          ]),
        ]),
      ]),
    ]),
  ])
}

fn venue_section() -> Element(msg) {
  section([class("py-16 px-4 bg-base-100")], [
    div([class("max-w-4xl mx-auto")], [
      h2([class("text-2xl font-bold text-center mb-12")], [text("会場")]),
      venue_card(),
    ]),
  ])
}

fn venue_card() -> Element(msg) {
  div([class("card bg-neutral text-neutral-content")], [
    div([class("card-body")], [
      div([class("flex items-center gap-3 mb-6")], [
        img([
          src("/icons/map-pin.svg"),
          attribute("alt", ""),
          class("w-6 h-6"),
        ]),
        h3([class("text-lg font-semibold")], [
          text("中野セントラルパーク カンファレンス"),
        ]),
      ]),
      div([class("text-sm mb-6")], [
        p([class("font-semibold mb-2")], [text("アクセス")]),
        ul([class("list-disc list-inside space-y-1")], [
          li([], [text("JR中央線・総武線「中野駅」北口より徒歩5分")]),
          li([], [text("東京メトロ東西線「中野駅」より徒歩5分")]),
        ]),
      ]),
      div([class("rounded-lg overflow-hidden")], [
        iframe([
          src(
            "https://www.google.com/maps/embed?pb=!1m14!1m8!1m3!1d6706.437024372982!2d139.6603819160998!3d35.70552369324171!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x6018f34668e0bc27%3A0x7d66caba722762c5!2z5Lit6YeO44K744Oz44OI44Op44Or44OR44O844Kv44Kr44Oz44OV44Kh44Os44Oz44K5!5e0!3m2!1sja!2sjp!4v1745237362764!5m2!1sja!2sjp",
          ),
          attribute("width", "100%"),
          attribute("height", "400"),
          attribute("style", "border:0;"),
          attribute("allowfullscreen", ""),
          attribute("loading", "lazy"),
          attribute("referrerpolicy", "no-referrer-when-downgrade"),
        ]),
      ]),
    ]),
  ])
}

fn not_found_page() -> Element(msg) {
  div([class("flex-1 flex items-center justify-center py-20")], [
    div([class("text-center")], [
      h1([class("text-6xl font-bold mb-4")], [text("404")]),
      p([class("text-xl mb-8")], [text("ページが見つかりません")]),
      button.primary(label: "ホームに戻る", url: "/"),
    ]),
  ])
}

fn footer() -> Element(msg) {
  html.footer(
    [
      class(
        "p-10 flex flex-col items-center gap-8 bg-base-200 text-base-content",
      ),
    ],
    [
      div(
        [
          class("footer sm:footer-horizontal max-w-2xl"),
        ],
        [
          nav([], [
            h3([class("footer-title")], [text("関数型まつり2026")]),
            nav_link(label: "行動規範", url: "/code-of-conduct"),
            nav_link(
              label: "お問い合わせ",
              url: "https://forms.gle/nwG9RnkP3AHWQtzh6",
            ),
            nav_link(
              label: "公式オンラインストア",
              url: "https://www.ttrinity.jp/shop/fp-matsuri/",
            ),
          ]),
          nav([], [
            h3([class("footer-title")], [text("過去の開催")]),
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
        ],
      ),
      aside([], [
        p([class("text-sm")], [text("© 2026 関数型まつり準備委員会")]),
      ]),
    ],
  )
}

fn is_external_link(url: String) -> Bool {
  string.starts_with(url, "http://") || string.starts_with(url, "https://")
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

// FFI -------------------------------------------------------------------------

@external(javascript, "./app.ffi.mjs", "setDocumentTitle")
fn set_document_title(title: String) -> Nil
