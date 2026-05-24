import gleam/int
import gleam/list
import gleam/option
import gleam/string
import layout.{type Page, Page}
import lustre/attribute.{attribute, class, src}
import lustre/element.{type Element}
import lustre/element/html.{a, div, h1, img, input, label, p, section, span, text}
import timetable.{
  type SpeakerData, type TalkData, type TalkTag, type TimetableEntry,
  type TimeslotData, TalkEntry, TimeslotEntry,
}

const px_per_row = 24

const grid_interval = 5

type TimeslotGroup {
  TimeslotGroup(
    title: String,
    starts_at: String,
    length_min: Int,
    min_track: Int,
    max_track: Int,
  )
}

pub fn page() -> Page(msg) {
  Page(title: "タイムテーブル | 関数型まつり2026", body: [
    page_header(),
    timetable_section(timetable.load_timetable()),
  ])
}

fn page_header() -> Element(msg) {
  section([class("pt-16 pb-8 px-4 bg-base-100")], [
    div([class("max-w-6xl mx-auto text-center")], [
      h1([class("text-3xl font-bold mb-4 tracking-tight")], [
        text("タイムテーブル"),
      ]),
    ]),
  ])
}

fn timetable_section(
  entries: Result(List(TimetableEntry), String),
) -> Element(msg) {
  section([class("pb-20 px-4 bg-base-100")], [
    div([class("max-w-6xl mx-auto")], [
      case entries {
        Error(_) -> error_state()
        Ok([]) -> empty_state()
        Ok(items) -> both_days(items)
      },
    ]),
  ])
}

fn both_days(entries: List(TimetableEntry)) -> Element(msg) {
  let day1 =
    list.filter(entries, fn(e) {
      timetable.get_day_number(timetable.entry_starts_at(e)) == 11
    })
  let day2 =
    list.filter(entries, fn(e) {
      timetable.get_day_number(timetable.entry_starts_at(e)) == 12
    })

  div([class("timetable-tabs")], [
    input([
      attribute("type", "radio"),
      attribute("id", "timetable-day-1"),
      attribute("name", "timetable-day"),
      attribute("checked", "checked"),
      class("timetable-tab-input"),
    ]),
    input([
      attribute("type", "radio"),
      attribute("id", "timetable-day-2"),
      attribute("name", "timetable-day"),
      class("timetable-tab-input"),
    ]),
    div([class("timetable-tab-list")], [
      label(
        [
          attribute("for", "timetable-day-1"),
          class("timetable-tab-label timetable-tab-label-day-1"),
        ],
        [text("Day 1（7/11）")],
      ),
      label(
        [
          attribute("for", "timetable-day-2"),
          class("timetable-tab-label timetable-tab-label-day-2"),
        ],
        [text("Day 2（7/12）")],
      ),
    ]),
    div([class("timetable-tab-panel timetable-tab-panel-day-1")], [
      day_section(day1),
    ]),
    div([class("timetable-tab-panel timetable-tab-panel-day-2")], [
      day_section(day2),
    ]),
  ])
}

fn day_section(entries: List(TimetableEntry)) -> Element(msg) {
  div([], [
    div([class("sticky top-0 z-10 bg-base-100 py-2 mb-2")], [
      div(
        [attribute("style", "display: grid; grid-template-columns: repeat(3, minmax(200px, 1fr)); gap: 2px; min-width: 600px;")],
        [
          track_header("Track A"),
          track_header("Track B"),
          track_header("Track C"),
        ],
      ),
    ]),
    div([class("overflow-x-auto")], [render_day_grid(entries)]),
  ])
}

fn track_header(name: String) -> Element(msg) {
  div(
    [
      class(
        "bg-base-200 rounded-sm py-1 text-center text-sm font-bold text-base-content/70",
      ),
    ],
    [text(name)],
  )
}

fn render_day_grid(entries: List(TimetableEntry)) -> Element(msg) {
  let day_start = day_grid_start(entries)
  let day_end = day_grid_end(entries)
  let total_rows = { day_end - day_start } / grid_interval

  let grid_style =
    "display: grid;"
    <> " grid-template-columns: repeat(3, minmax(200px, 1fr));"
    <> " grid-template-rows: repeat("
    <> int.to_string(total_rows)
    <> ", "
    <> int.to_string(px_per_row)
    <> "px);"
    <> " gap: 2px;"
    <> " min-width: 600px;"

  let cells =
    list.flatten([
      render_hour_marker_cells(day_start, day_end),
      render_timeslot_cells(entries, day_start),
      render_talk_cells(entries, day_start),
    ])

  div([attribute("style", grid_style)], cells)
}

fn render_hour_marker_cells(day_start: Int, day_end: Int) -> List(Element(msg)) {
  let first_marker = next_hour_mark(day_start)

  hour_marks(first_marker, day_end)
  |> list.map(fn(minutes) {
    let row = { minutes - day_start } / grid_interval + 1
    let marker_style =
      "grid-column: 1 / 4; grid-row: "
      <> int.to_string(row)
      <> " / span 1;"

    div(
      [
        attribute("style", marker_style),
        class(
          "pointer-events-none relative z-20 h-0 border-t border-base-content/20",
        ),
      ],
      [
        span(
          [
            class(
              "absolute -top-2 left-0 bg-base-100 pr-2 text-[10px] font-bold leading-none text-base-content/50",
            ),
          ],
          [text(format_minutes(minutes))],
        ),
      ],
    )
  })
}

fn next_hour_mark(minutes: Int) -> Int {
  case minutes % 60 {
    0 -> minutes
    remainder -> minutes + 60 - remainder
  }
}

fn hour_marks(current: Int, end: Int) -> List(Int) {
  case current >= end {
    True -> []
    False -> [current, ..hour_marks(current + 60, end)]
  }
}

fn day_grid_start(entries: List(TimetableEntry)) -> Int {
  list.map(entries, fn(e) {
    timetable.get_start_minutes(timetable.entry_starts_at(e))
  })
  |> list.fold(99999, int.min)
}

fn day_grid_end(entries: List(TimetableEntry)) -> Int {
  list.map(entries, fn(e) {
    timetable.get_start_minutes(timetable.entry_starts_at(e))
    + timetable.entry_length_min(e)
  })
  |> list.fold(0, int.max)
}

fn render_timeslot_cells(
  entries: List(TimetableEntry),
  day_start: Int,
) -> List(Element(msg)) {
  entries
  |> group_timeslots
  |> list.map(fn(group: TimeslotGroup) {
    let row_start = entry_grid_row(group.starts_at, day_start)
    let row_end = row_start + group.length_min / grid_interval
    let col_start = group.min_track
    let col_end = group.max_track + 1
    let cell_style =
      "grid-column: "
      <> int.to_string(col_start)
      <> " / "
      <> int.to_string(col_end)
      <> "; grid-row: "
      <> int.to_string(row_start)
      <> " / "
      <> int.to_string(row_end)
      <> ";"
    div(
      [
        attribute("style", cell_style),
        class(
          "bg-base-200 text-base-content/60 rounded-sm flex items-center gap-2 overflow-hidden p-2",
        ),
      ],
      [
        span([class("text-xs font-bold shrink-0 text-base-content/50")], [
          text(timetable.get_time_label(group.starts_at)),
        ]),
        span([class("text-xs leading-snug")], [text(group.title)]),
      ],
    )
  })
}

fn render_talk_cells(
  entries: List(TimetableEntry),
  day_start: Int,
) -> List(Element(msg)) {
  entries
  |> list.filter_map(fn(e) {
    case e {
      TalkEntry(t) -> Ok(t)
      TimeslotEntry(_) -> Error(Nil)
    }
  })
  |> list.map(fn(talk: TalkData) {
    let row_start = entry_grid_row(talk.starts_at, day_start)
    let row_end = row_start + talk.length_min / grid_interval
    let col = talk.track.sort
    let cell_style =
      "grid-column: "
      <> int.to_string(col)
      <> "; grid-row: "
      <> int.to_string(row_start)
      <> " / "
      <> int.to_string(row_end)
      <> ";"
    let is_compact = talk.length_min <= 10
    a(
      [
        attribute("href", proposal_url(talk.uuid)),
        attribute("target", "_blank"),
        attribute("rel", "noopener noreferrer"),
        attribute("style", cell_style),
        class(
          "bg-neutral border border-subtle rounded-sm p-1.5 overflow-hidden flex flex-col gap-1 text-neutral-content no-underline transition-colors hover:bg-base-200/40",
        ),
      ],
      [
        p([class("text-xs text-base-content/40 leading-none shrink-0")], [
          text(format_time_range(talk.starts_at, talk.length_min)),
        ]),
        p([class("text-xs font-medium leading-snug line-clamp-3")], [
          text(talk.title),
        ]),
        case is_compact {
          True -> div([], [])
          False ->
            div([class("flex flex-col gap-1 mt-auto shrink-0")], [
              render_speaker(talk.speaker),
              render_tags(talk.tags),
            ])
        },
      ],
    )
  })
}

fn proposal_url(uuid: String) -> String {
  "https://fortee.jp/2026fp-matsuri/proposal/" <> uuid
}

fn render_speaker(speaker: option.Option(SpeakerData)) -> Element(msg) {
  case speaker {
    option.None -> div([], [])
    option.Some(s) ->
      div([class("flex items-center gap-1.5 shrink-0")], [
        case s.avatar_url {
          option.None ->
            div([class("w-5 h-5 rounded-full bg-base-200 shrink-0")], [])
          option.Some(url) ->
            img([
              src(url),
              attribute("alt", s.name),
              class(
                "w-5 h-5 rounded-full object-cover border border-black/5 shrink-0",
              ),
            ])
        },
        span([class("text-xs text-secondary leading-none truncate")], [
          text(s.name),
        ]),
      ])
  }
}

fn render_tags(tags: List(TalkTag)) -> Element(msg) {
  case tags {
    [] -> div([], [])
    _ ->
      div(
        [class("flex flex-wrap gap-1")],
        list.map(tags, fn(tag: TalkTag) {
          span(
            [
              class(
                "badge badge-xs badge-outline border-base-content/20 text-base-content",
              ),
            ],
            [text(tag.name)],
          )
        }),
      )
  }
}

fn entry_grid_row(starts_at: String, day_start: Int) -> Int {
  { timetable.get_start_minutes(starts_at) - day_start } / grid_interval + 1
}

fn format_time_range(starts_at: String, length_min: Int) -> String {
  let start = timetable.get_time_label(starts_at)
  let end_min = timetable.get_start_minutes(starts_at) + length_min
  let end = format_minutes(end_min)
  start <> "-" <> end
}

fn format_minutes(minutes: Int) -> String {
  let end_h = minutes / 60
  let end_m = minutes % 60
  pad2(end_h) <> ":" <> pad2(end_m)
}

fn pad2(n: Int) -> String {
  let s = int.to_string(n)
  case string.length(s) {
    1 -> "0" <> s
    _ -> s
  }
}

fn group_timeslots(entries: List(TimetableEntry)) -> List(TimeslotGroup) {
  let timeslots: List(TimeslotData) =
    list.filter_map(entries, fn(e) {
      case e {
        TimeslotEntry(t) -> Ok(t)
        TalkEntry(_) -> Error(Nil)
      }
    })

  list.fold(timeslots, [], fn(groups: List(TimeslotGroup), ts: TimeslotData) {
    let key = ts.starts_at <> "|" <> ts.title
    case
      list.find(groups, fn(g: TimeslotGroup) {
        g.starts_at <> "|" <> g.title == key
      })
    {
      Ok(existing) -> {
        let updated =
          TimeslotGroup(
            ..existing,
            min_track: int.min(existing.min_track, ts.track.sort),
            max_track: int.max(existing.max_track, ts.track.sort),
          )
        list.map(groups, fn(g: TimeslotGroup) {
          case g.starts_at <> "|" <> g.title == key {
            True -> updated
            False -> g
          }
        })
      }
      Error(_) ->
        list.append(groups, [
          TimeslotGroup(
            title: ts.title,
            starts_at: ts.starts_at,
            length_min: ts.length_min,
            min_track: ts.track.sort,
            max_track: ts.track.sort,
          ),
        ])
    }
  })
}

fn empty_state() -> Element(msg) {
  div([class("card bg-base-200 border border-subtle shadow-none")], [
    div([class("card-body p-8 text-center")], [
      p([class("text-base leading-relaxed")], [
        text("現在表示できるタイムテーブルはありません。"),
      ]),
    ]),
  ])
}

fn error_state() -> Element(msg) {
  div([class("card bg-base-200 border border-subtle shadow-none")], [
    div([class("card-body p-8 text-center")], [
      p([class("text-base leading-relaxed")], [
        text("タイムテーブル情報を読み込めませんでした。"),
      ]),
    ]),
  ])
}
