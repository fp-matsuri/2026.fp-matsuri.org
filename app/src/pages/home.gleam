import cloud
import components/button
import gleam/dynamic/decode
import gleam/int
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import layout.{type Page, Page}
import lustre/attribute.{attribute, class, id, src}
import lustre/element.{type Element}
import lustre/element/html.{
  a, br, div, h2, h3, img, li, p, section, span, table, tbody, td, text, th,
  thead, tr, ul,
}
import simplifile
import sponsor.{type Sponsor, Community, Individual, Sponsor}
import team

pub fn page() -> Page(msg) {
  Page(title: "関数型まつり2026", body: [
    hero_section(),
    announcements_section(),
    about_section(),
    ticket_section(),
    sponsor_recruitment_section(),
    team_section(),
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

// Announcements Section
type SocialLinks {
  SocialLinks(x: String, bluesky: String, hatena: Option(String))
}

type Announcement {
  Announcement(posted_on: String, headline: String, links: SocialLinks)
}

fn social_links_decoder() -> decode.Decoder(SocialLinks) {
  use x <- decode.field("x", decode.string)
  use bluesky <- decode.field("bluesky", decode.string)
  use hatena <- decode.optional_field(
    "hatena",
    None,
    decode.optional(decode.string),
  )
  decode.success(SocialLinks(x:, bluesky:, hatena:))
}

fn announcement_decoder() -> decode.Decoder(Announcement) {
  use posted_on <- decode.field("posted_on", decode.string)
  use headline <- decode.field("headline", decode.string)
  use links <- decode.field("links", social_links_decoder())
  decode.success(Announcement(posted_on:, headline:, links:))
}

fn load_announcements(file_path: String) -> List(Announcement) {
  {
    use content <- result.try(
      simplifile.read(file_path)
      |> result.replace_error(Nil),
    )
    use announcements <- result.try(
      json.parse(content, decode.list(announcement_decoder()))
      |> result.replace_error(Nil),
    )
    Ok(announcements)
  }
  |> result.unwrap([])
}

fn announcements_section() -> Element(msg) {
  let announcements =
    load_announcements("../content/announcements.json")
    |> list.sort(fn(a, b) { string.compare(b.posted_on, a.posted_on) })
  section([class("py-20 px-6 bg-base-200")], [
    div([class("max-w-2xl mx-auto")], [
      h2([class("text-2xl font-bold text-center mb-10 tracking-tight")], [
        text("お知らせ"),
      ]),
      ul(
        [class("list rounded-box divide-y divide-base-content/15")],
        list.map(announcements, fn(announcement) {
          announcement_item(announcement)
        }),
      ),
    ]),
  ])
}

fn format_date(date_str: String) -> String {
  case string.split(date_str, "-") {
    [year, month, day] -> {
      let year_int = int.parse(year) |> result.unwrap(0)
      let month_int = int.parse(month) |> result.unwrap(0)
      let day_int = int.parse(day) |> result.unwrap(0)
      int.to_string(year_int)
      <> "年"
      <> int.to_string(month_int)
      <> "月"
      <> int.to_string(day_int)
      <> "日"
    }
    _ -> date_str
  }
}

fn announcement_item(announcement: Announcement) -> Element(msg) {
  let Announcement(posted_on:, headline:, links:) = announcement
  let formatted_date = format_date(posted_on)

  let hatena_link = case links.hatena {
    Some(url) -> [
      social_link(url:, icon: "/icons/hatenablog.svg", label: "はてなブログで投稿を見る"),
    ]
    None -> []
  }

  let social_links =
    list.append(hatena_link, [
      social_link(url: links.x, icon: "/icons/x.svg", label: "Xで投稿を見る"),
      social_link(
        url: links.bluesky,
        icon: "/icons/bluesky.svg",
        label: "Blueskyで投稿を見る",
      ),
    ])

  li(
    [
      class("flex flex-col sm:flex-row sm:items-center gap-1.5 sm:gap-4 py-4"),
    ],
    [
      div([class("flex-1")], [
        div([], [
          span([class("text-sm text-base-content/70")], [text(formatted_date)]),
        ]),
        div([class("mt-1")], [
          p([class("text-base leading-relaxed")], [text(headline)]),
        ]),
      ]),
      div([class("flex gap-4 items-center mt-1 sm:mt-0 ml-auto")], social_links),
    ],
  )
}

fn social_link(url url: String, icon icon: String, label label: String) {
  a(
    [
      attribute("href", url),
      attribute("target", "_blank"),
      attribute("rel", "noopener noreferrer"),
      class("hover:opacity-80 transition-opacity"),
      attribute("aria-label", label),
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
              text("「関数型まつり2026」を開催します！"),
            ]),
            p([class("text-base leading-relaxed")], [
              text(
                "昨年の「関数型まつり」では、参加者総数494名、登壇者48名による多様なセッションを実施し、言語コミュニティの垣根を越えた交流と学びが生まれました。
              好評をいただき、今年も「関数型まつり2026」を開催します！",
              ),
            ]),
            div([class("divider")], []),
            p([class("mb-4 text-base leading-relaxed")], [
              text(
                "関数型プログラミングはメジャーな言語・フレームワークに取り入れられ、広く実践されるようになりました。
                そしてその手法自体も進化し続けています。
                その一方で「難しい・とっつきにくい」という声もあり、十分に普及しているとまではいえないかもしれません。",
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

// Ticket Section
fn ticket_section() -> Element(msg) {
  section([id("tickets"), class("py-20 px-6 bg-base-100")], [
    div([class("max-w-2xl mx-auto")], [
      h2([class("text-2xl font-bold text-center mb-10 tracking-tight")], [
        text("チケット"),
      ]),
      div(
        [
          class(
            "card bg-neutral text-neutral-content border border-subtle shadow-none",
          ),
        ],
        [
          div([class("card-body p-8 md:p-10")], [
            div([class("overflow-x-auto mb-8")], [
              table([class("table w-full")], [
                thead([], [
                  tr([], [
                    th([], [text("種別")]),
                    th([class("text-right")], [text("金額（税込）")]),
                  ]),
                ]),
                tbody([], [
                  ticket_row(
                    "一般（懇親会なし）",
                    "General Admission (Conference Only)",
                    10_000,
                  ),
                  ticket_row(
                    "一般（懇親会あり）",
                    "General Admission (with After-party)",
                    16_000,
                  ),
                  ticket_row("学生（懇親会なし）", "Student (Conference Only)", 5000),
                  ticket_row("学生（懇親会あり）", "Student (with After-party)", 8000),
                  ticket_row(
                    "懇親会のみ ※締め切り注意",
                    "After-party Only (*Please note the deadline)",
                    6000,
                  ),
                  ticket_row("1日券（懇親会なし）", "1-Day Pass (Conference Only)", 5000),
                ]),
              ]),
            ]),
            div([class("card-actions justify-center")], [
              button.primary(
                label: "チケットを購入（Doorkeeper）",
                url: "https://fp-matsuri.doorkeeper.jp/events/196475",
              ),
            ]),
          ]),
        ],
      ),
    ]),
  ])
}

fn ticket_row(ja: String, en: String, price: Int) -> Element(msg) {
  tr([], [
    td([], [
      span([class("block")], [text(ja)]),
      span([class("block text-sm text-base-content/60")], [text(en)]),
    ]),
    td([class("text-right tabular-nums whitespace-nowrap")], [
      text("¥" <> format_ticket_price(price)),
    ]),
  ])
}

fn format_ticket_price(price: Int) -> String {
  let s = int.to_string(price)
  let len = string.length(s)
  case len > 3 {
    True -> string.slice(s, 0, len - 3) <> "," <> string.slice(s, len - 3, 3)
    False -> s
  }
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
    div([class("max-w-2xl mx-auto")], [sponsor_logos()]),
  ])
}

// スポンサーロゴ表示
fn sponsor_logos() -> Element(msg) {
  element.fragment([
    sponsor_plan(
      title: "プラチナスポンサー",
      sponsors: sponsor.platinum_sponsors(),
      grid_template: "grid-cols-[repeat(1,304px)] sm:grid-cols-[repeat(2,328px)]",
    ),
    sponsor_plan(
      title: "ゴールドスポンサー",
      sponsors: sponsor.gold_sponsors(),
      grid_template: "grid-cols-[repeat(2,144px)] sm:grid-cols-[repeat(2,248px)]",
    ),
    sponsor_plan(
      title: "シルバースポンサー",
      sponsors: sponsor.silver_sponsors(),
      grid_template: "grid-cols-[repeat(3,96px)] sm:grid-cols-[repeat(3,168px)]",
    ),
    sponsor_plan(
      title: "ロゴスポンサー",
      sponsors: sponsor.logo_sponsors(),
      grid_template: "grid-cols-[repeat(3,80px)] sm:grid-cols-[repeat(4,128px)]",
    ),
    cheerleader_plan(sponsor.cheerleader_sponsors()),
    sponsor_plan(
      title: "協力",
      sponsors: sponsor.support_sponsors(),
      grid_template: "grid-cols-[repeat(1,80px)] sm:grid-cols-[repeat(1,128px)]",
    ),
  ])
}

type SponsorEntry {
  SponsorEntry(id: String, sponsor: Sponsor)
}

fn plan_section(
  title: String,
  grid_class: String,
  sponsors: List(Sponsor),
  render_logo: fn(SponsorEntry) -> Element(msg),
) -> Element(msg) {
  let entries =
    list.map(sponsors, fn(s) { SponsorEntry(id: popover_id(s), sponsor: s) })
  div([class("pt-8")], [
    h3([class("text-xl font-semibold text-center")], [text(title)]),
    div([class(grid_class)], list.map(entries, render_logo)),
    element.fragment(list.map(entries, sponsor_popover)),
  ])
}

fn sponsor_plan(
  title title: String,
  sponsors sponsors: List(Sponsor),
  grid_template grid_template: String,
) -> Element(msg) {
  plan_section(
    title,
    "grid " <> grid_template <> " gap-2 mt-8 justify-items-center justify-center",
    sponsors,
    sponsor_logo_button,
  )
}

fn cheerleader_plan(sponsors: List(Sponsor)) -> Element(msg) {
  plan_section(
    "応援団",
    "grid grid-cols-4 sm:grid-cols-[repeat(auto-fit,100px)] gap-x-2.5 gap-y-5 sm:gap-y-[30px] mt-8 justify-center",
    sponsors,
    cheerleader_logo_button,
  )
}

fn popover_id(s: Sponsor) -> String {
  "sponsor-" <> s.slug
}

fn sponsor_logo_button(entry: SponsorEntry) -> Element(msg) {
  let SponsorEntry(id:, sponsor: Sponsor(name:, image:, ..)) = entry
  html.button(
    [
      attribute("type", "button"),
      attribute("popovertarget", id),
      class(
        "btn btn-ghost shadow-none w-full h-auto p-0 border-0 bg-transparent transition-transform hover:scale-[1.02]",
      ),
    ],
    [
      img([
        src(image),
        attribute("alt", name),
        class(
          "w-full h-auto aspect-[21/9] object-contain bg-white rounded-lg shadow-sm",
        ),
      ]),
    ],
  )
}

fn cheerleader_logo_button(entry: SponsorEntry) -> Element(msg) {
  let SponsorEntry(id:, sponsor: Sponsor(name:, image:, kind:, ..)) = entry
  let img_class = case kind {
    Individual -> "w-10 h-10 object-cover rounded-full border border-black/5"
    Community -> "h-10 rounded-sm"
  }
  html.button(
    [
      attribute("type", "button"),
      attribute("popovertarget", id),
      class(
        "btn btn-ghost shadow-none flex-col gap-2 h-auto p-2 border-0 bg-transparent transition-transform hover:scale-[1.05]",
      ),
    ],
    [
      img([src(image), attribute("alt", name), class(img_class)]),
      span([class("text-[10px] text-center [text-wrap:balance]")], [text(name)]),
    ],
  )
}

fn sponsor_popover(entry: SponsorEntry) -> Element(msg) {
  let SponsorEntry(
    id: popover_id,
    sponsor: Sponsor(name:, image:, href:, plan:, description:, ..),
  ) = entry

  let close_button =
    html.button(
      [
        attribute("type", "button"),
        attribute("popovertarget", popover_id),
        attribute("popovertargetaction", "hide"),
        attribute("aria-label", "閉じる"),
        class(
          "btn btn-sm btn-circle btn-neutral shadow-none absolute top-3 right-3",
        ),
      ],
      [text("✕")],
    )

  let logo =
    img([
      src(image),
      attribute("alt", name),
      class(
        "w-64 h-auto aspect-[21/9] object-contain rounded-lg shrink-0 mx-auto",
      ),
    ])

  let plan_badge =
    div([class("flex justify-center mt-3")], [
      span([class("badge badge-outline badge-sm")], [
        text(sponsor.plan_label(plan)),
      ]),
    ])

  let title =
    h3([class("text-lg font-bold mb-2 text-center")], [text(name)])

  let description_block = case description {
    "" -> element.none()
    _ ->
      element.unsafe_raw_html(
        "",
        "div",
        [
          class(
            "prose prose-sm max-w-none mb-4
            prose-headings:font-bold
            prose-p:leading-relaxed
            prose-a:text-primary
            prose-ul:list-disc prose-ul:pl-6",
          ),
        ],
        description,
      )
  }

  let link_block = case href {
    "" -> element.none()
    _ ->
      div([class("flex justify-center mt-2")], [
        button.primary(label: "サイトを見る", url: href),
      ])
  }

  div(
    [
      id(popover_id),
      attribute("popover", "auto"),
      class(
        "sponsor-popover card fixed inset-0 m-auto w-fit h-fit bg-base-100 text-base-content max-w-xl max-h-[85vh] overflow-y-auto",
      ),
    ],
    [
      div([class("card-body relative")], [
        close_button,
        logo,
        plan_badge,
        title,
        description_block,
        link_block,
      ]),
    ],
  )
}

// Team Section
fn team_section() -> Element(msg) {
  section([id("team"), class("py-20 px-6 bg-base-100")], [
    div([class("max-w-2xl mx-auto")], [
      h2([class("text-2xl font-bold text-center mb-10 tracking-tight")], [
        text("Team"),
      ]),
      members_section("座長", team.leaders()),
      members_section("スタッフ", team.staff()),
    ]),
  ])
}

fn members_section(title: String, members: List(team.Member)) -> Element(msg) {
  let member_to_item = fn(member) {
    a(
      [
        class(
          "flex flex-col items-center gap-2 p-2 rounded-lg hover:bg-base-200"
          <> "transition-colors no-underline text-inherit text-[10px] text-center",
        ),
        attribute("target", "_blank"),
        attribute("rel", "noopener noreferrer"),
        attribute("href", member |> team.github_url),
      ],
      [
        img([
          class("w-10 h-10 object-cover rounded-full border border-black/5"),
          attribute("alt", member.id),
          src(member |> team.avatar_url),
        ]),
        span([], [text(member.id)]),
      ],
    )
  }
  div([class("mb-8")], [
    h3(
      [class("text-base font-semibold text-center text-base-content/60 mb-4")],
      [text(title)],
    ),
    div(
      [
        class(
          "grid grid-cols-[repeat(auto-fill,minmax(80px,1fr))] gap-2 justify-center",
        ),
      ],
      members |> list.map(member_to_item),
    ),
  ])
}
