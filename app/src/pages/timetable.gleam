import gleam/int
import gleam/list
import gleam/option
import gleam/string
import layout.{type Page, Page}
import lustre/attribute.{attribute, class}
import lustre/element.{type Element}
import lustre/element/html.{div, h1, h2, p, section, span, text}
import timetable.{
  type TalkData, type TimetableEntry, type TimeslotData, TalkEntry, TimeslotEntry,
}

const px_per_row = 14

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

  div([class("flex flex-col gap-16")], [
    day_section("Day 1（7/11）", day1),
    day_section("Day 2（7/12）", day2),
  ])
}

fn day_section(title: String, entries: List(TimetableEntry)) -> Element(msg) {
  div([], [
    div([class("sticky top-0 z-10 bg-base-100 py-2 mb-2")], [
      h2([class("text-xl font-bold mb-3")], [text(title)]),
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
      render_timeslot_cells(entries, day_start),
      render_talk_cells(entries, day_start),
    ])

  div([attribute("style", grid_style)], cells)
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
    div(
      [
        attribute("style", cell_style),
        class(
          "bg-neutral border border-subtle rounded-sm p-1.5 overflow-hidden flex flex-col gap-1 text-neutral-content",
        ),
      ],
      [
        p([class("text-xs text-base-content/40 leading-none shrink-0")], [
          text(format_time_range(talk.starts_at, talk.length_min)),
        ]),
        p([class("text-xs font-medium leading-snug grow overflow-hidden")], [
          text(talk.title),
        ]),
        case talk.speaker {
          option.Some(s) ->
            p(
              [class("text-xs text-secondary leading-none truncate shrink-0")],
              [text(s.name)],
            )
          option.None -> div([], [])
        },
      ],
    )
  })
}

fn entry_grid_row(starts_at: String, day_start: Int) -> Int {
  { timetable.get_start_minutes(starts_at) - day_start } / grid_interval + 1
}

fn format_time_range(starts_at: String, length_min: Int) -> String {
  let start = timetable.get_time_label(starts_at)
  let end_min = timetable.get_start_minutes(starts_at) + length_min
  let end_h = end_min / 60
  let end_m = end_min % 60
  let end =
    pad2(end_h)
    <> ":"
    <> pad2(end_m)
  start <> "-" <> end
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
