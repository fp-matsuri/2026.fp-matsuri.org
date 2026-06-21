import gleam/int
import gleam/list
import gleam/option
import gleam/order
import gleam/string
import layout.{type Page, Page}
import lustre/attribute.{attribute, class, src}
import lustre/element.{type Element}
import lustre/element/html.{a, div, h1, header, img, p, section, span, text}
import timetable.{
  type SpeakerData, type TalkData, type TalkTag, type TimeslotData,
  type TimetableEntry, TalkEntry, TimeslotEntry,
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

type ScheduleItem {
  ScheduleTimeslot(TimeslotGroup)
  ScheduleTalk(TalkData)
}

pub fn page() -> Page(msg) {
  Page(title: "タイムテーブル | 関数型まつり2026", body: [
    page_header(),
    timetable_section(timetable.load_schedule()),
  ])
}

fn page_header() -> Element(msg) {
  section([class("pt-16 pb-8 px-4 bg-base-100")], [
    div([class("max-w-[850px] mx-auto")], [
      h1([class("text-3xl font-bold mb-4 tracking-tight")], [
        text("タイムテーブル"),
      ]),
      p([class("text-base leading-relaxed text-secondary")], [
        text("関数型まつり2026のタイムテーブルです。"),
      ]),
    ]),
  ])
}

fn timetable_section(
  entries: Result(List(TimetableEntry), String),
) -> Element(msg) {
  section([class("pb-20 px-4 bg-base-100")], [
    div([class("max-w-[850px] mx-auto")], [
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

  div([class("space-y-16")], [
    day_section("day1", "Day 1", "2026年7月11日（土）", day1),
    day_section("day2", "Day 2", "2026年7月12日（日）", day2),
  ])
}

fn day_section(
  id: String,
  title: String,
  date_label: String,
  entries: List(TimetableEntry),
) -> Element(msg) {
  section([attribute("id", id), class("scroll-mt-6")], [
    header(
      [
        class(
          "sticky top-0 z-30 grid gap-2 border-b border-subtle bg-base-100 py-2",
        ),
      ],
      [
        div([class("text-lg font-bold")], [text(title <> "：" <> date_label)]),
        div([class("hidden grid-cols-3 gap-2 sm:grid")], [
          track_header("Track A", "#CE3F3D", "oklch(61% 0.2 40 / 0.12)"),
          track_header("Track B", "#ff8f00", "oklch(70% 0.15 70 / 0.18)"),
          track_header("Track C", "#5352A0", "oklch(65% 0.18 250 / 0.12)"),
        ]),
      ],
    ),
    render_day_grid(entries),
  ])
}

fn track_header(
  name: String,
  text_color: String,
  background_color: String,
) -> Element(msg) {
  div(
    [
      attribute(
        "style",
        "color: "
          <> text_color
          <> "; background-color: "
          <> background_color
          <> ";",
      ),
      class("rounded-[5px] px-2 py-1 text-center text-sm font-bold"),
    ],
    [text(name)],
  )
}

fn render_day_grid(entries: List(TimetableEntry)) -> Element(msg) {
  let day_start = day_grid_start(entries)
  let day_end = day_grid_end(entries)
  let total_rows = { day_end - day_start } / grid_interval

  let grid_style =
    "grid-template-rows: repeat("
    <> int.to_string(total_rows)
    <> ", minmax("
    <> int.to_string(px_per_row)
    <> "px, auto));"

  div(
    [
      attribute("style", grid_style),
      class(
        "mt-4 flex flex-col gap-2 sm:grid sm:grid-cols-3 sm:gap-x-2 sm:gap-y-0",
      ),
    ],
    entries
      |> schedule_items
      |> list.sort(by: compare_schedule_items)
      |> list.map(fn(item) { render_schedule_item(item, day_start) }),
  )
}

fn day_grid_start(entries: List(TimetableEntry)) -> Int {
  list.map(entries, fn(e) {
    timetable.get_start_minutes(timetable.entry_starts_at(e))
  })
  |> list.fold(99_999, int.min)
}

fn day_grid_end(entries: List(TimetableEntry)) -> Int {
  list.map(entries, fn(e) {
    timetable.get_start_minutes(timetable.entry_starts_at(e))
    + timetable.entry_length_min(e)
  })
  |> list.fold(0, int.max)
}

fn schedule_items(entries: List(TimetableEntry)) -> List(ScheduleItem) {
  let timeslots = entries |> group_timeslots |> list.map(ScheduleTimeslot)
  let talks =
    entries
    |> list.filter_map(fn(e) {
      case e {
        TalkEntry(t) -> Ok(t)
        TimeslotEntry(_) -> Error(Nil)
      }
    })
    |> list.map(ScheduleTalk)

  list.append(timeslots, talks)
}

fn compare_schedule_items(a: ScheduleItem, b: ScheduleItem) -> order.Order {
  case
    int.compare(schedule_item_start_minutes(a), schedule_item_start_minutes(b))
  {
    order.Eq ->
      int.compare(schedule_item_track_sort(a), schedule_item_track_sort(b))
    other -> other
  }
}

fn schedule_item_start_minutes(item: ScheduleItem) -> Int {
  case item {
    ScheduleTimeslot(group) -> timetable.get_start_minutes(group.starts_at)
    ScheduleTalk(talk) -> timetable.get_start_minutes(talk.starts_at)
  }
}

fn schedule_item_track_sort(item: ScheduleItem) -> Int {
  case item {
    ScheduleTimeslot(group) -> group.min_track
    ScheduleTalk(talk) -> talk.track.sort
  }
}

fn render_schedule_item(item: ScheduleItem, day_start: Int) -> Element(msg) {
  case item {
    ScheduleTimeslot(group) -> render_timeslot(group, day_start)
    ScheduleTalk(talk) -> render_talk(talk, day_start)
  }
}

fn render_timeslot(group: TimeslotGroup, day_start: Int) -> Element(msg) {
  let row_start = entry_grid_row(group.starts_at, day_start)
  let row_end = row_start + group.length_min / grid_interval
  let cell_style =
    "grid-column: "
    <> int.to_string(group.min_track)
    <> " / "
    <> int.to_string(group.max_track + 1)
    <> "; grid-row: "
    <> int.to_string(row_start)
    <> " / "
    <> int.to_string(row_end)
    <> ";"

  div(
    [
      attribute("style", cell_style),
      class(
        "grid grid-cols-[auto_1fr] items-center gap-x-2 rounded-sm bg-base-200 p-2 text-sm text-base-content/70 sm:mt-2",
      ),
    ],
    [
      span([class("font-bold")], [
        text(format_time_range(group.starts_at, group.length_min)),
      ]),
      text(group.title),
    ],
  )
}

fn render_talk(talk: TalkData, day_start: Int) -> Element(msg) {
  let row_start = entry_grid_row(talk.starts_at, day_start)
  let display_length_min = talk_display_length_min(talk)
  let row_end = row_start + display_length_min / grid_interval
  let cell_style =
    "grid-column: "
    <> int.to_string(talk.track.sort)
    <> "; grid-row: "
    <> int.to_string(row_start)
    <> " / "
    <> int.to_string(row_end)
    <> ";"
  let is_compact = talk.length_min <= 10

  a(
    [
      attribute("href", talk_url(talk)),
      attribute("target", "_blank"),
      attribute("rel", "noopener noreferrer"),
      attribute("style", cell_style),
      class(
        "grid grid-rows-[auto_auto_auto_1fr] content-start gap-1 overflow-hidden rounded-sm border border-subtle bg-neutral p-2 text-neutral-content no-underline transition-colors hover:border-primary sm:mt-2",
      ),
    ],
    [
      p([class("text-xs font-bold leading-none text-base-content/60")], [
        text(format_time_range(talk.starts_at, talk.length_min)),
        span([class("font-normal")], [
          text("（" <> int.to_string(talk.length_min) <> "min）"),
        ]),
      ]),
      p([class("text-sm leading-snug")], [
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
}

fn talk_display_length_min(talk: TalkData) -> Int {
  case is_day2_lightning_talk_to_expand(talk) {
    True -> 15
    False -> talk.length_min
  }
}

fn is_day2_lightning_talk_to_expand(talk: TalkData) -> Bool {
  talk.length_min == 10
  && {
    talk.starts_at == "2026-07-12T14:00:00+09:00"
    || talk.starts_at == "2026-07-12T14:15:00+09:00"
  }
}

fn proposal_url(uuid: String) -> String {
  "https://fortee.jp/2026fp-matsuri/proposal/" <> uuid
}

fn talk_url(talk: TalkData) -> String {
  case talk.url {
    option.Some(url) -> url
    option.None -> proposal_url(talk.uuid)
  }
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
