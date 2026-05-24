import gleam/dynamic/decode
import gleam/int
import gleam/json
import gleam/option.{type Option, None}
import gleam/result
import gleam/string
import simplifile

pub type TimetableEntry {
  TimeslotEntry(TimeslotData)
  TalkEntry(TalkData)
}

pub type TimeslotData {
  TimeslotData(
    uuid: String,
    title: String,
    track: TrackData,
    starts_at: String,
    length_min: Int,
  )
}

pub type TalkData {
  TalkData(
    uuid: String,
    title: String,
    track: TrackData,
    starts_at: String,
    length_min: Int,
    tags: List(TalkTag),
    speaker: Option(SpeakerData),
  )
}

pub type TrackData {
  TrackData(name: String, sort: Int)
}

pub type TalkTag {
  TalkTag(name: String)
}

pub type SpeakerData {
  SpeakerData(name: String, kana: String, avatar_url: Option(String))
}

const timetable_file_path = "../content/timetable.json"

pub fn load_timetable() -> Result(List(TimetableEntry), String) {
  use content <- result.try(
    simplifile.read(timetable_file_path)
    |> result.replace_error("timetable.json を読み込めませんでした"),
  )
  use entries <- result.try(
    json.parse(content, timetable_decoder())
    |> result.replace_error("timetable.json を decode できませんでした"),
  )
  Ok(entries)
}

fn timetable_decoder() -> decode.Decoder(List(TimetableEntry)) {
  use entries <- decode.field("timetable", decode.list(entry_decoder()))
  decode.success(entries)
}

fn entry_decoder() -> decode.Decoder(TimetableEntry) {
  use type_str <- decode.field("type", decode.string)
  case type_str {
    "talk" -> talk_entry_decoder()
    _ -> timeslot_entry_decoder()
  }
}

fn talk_entry_decoder() -> decode.Decoder(TimetableEntry) {
  use uuid <- decode.field("uuid", decode.string)
  use title <- decode.field("title", decode.string)
  use track <- decode.field("track", track_decoder())
  use starts_at <- decode.field("starts_at", decode.string)
  use length_min <- decode.field("length_min", decode.int)
  use tags <- decode.field("tags", decode.list(tag_decoder()))
  use speaker <- decode.optional_field(
    "speaker",
    None,
    decode.optional(speaker_decoder()),
  )
  decode.success(TalkEntry(TalkData(
    uuid:,
    title:,
    track:,
    starts_at:,
    length_min:,
    tags:,
    speaker:,
  )))
}

fn timeslot_entry_decoder() -> decode.Decoder(TimetableEntry) {
  use uuid <- decode.field("uuid", decode.string)
  use title <- decode.field("title", decode.string)
  use track <- decode.field("track", track_decoder())
  use starts_at <- decode.field("starts_at", decode.string)
  use length_min <- decode.field("length_min", decode.int)
  decode.success(TimeslotEntry(TimeslotData(
    uuid:,
    title:,
    track:,
    starts_at:,
    length_min:,
  )))
}

fn track_decoder() -> decode.Decoder(TrackData) {
  use name <- decode.field("name", decode.string)
  use sort <- decode.field("sort", decode.int)
  decode.success(TrackData(name:, sort:))
}

fn tag_decoder() -> decode.Decoder(TalkTag) {
  use name <- decode.field("name", decode.string)
  decode.success(TalkTag(name:))
}

fn speaker_decoder() -> decode.Decoder(SpeakerData) {
  use name <- decode.field("name", decode.string)
  use kana <- decode.optional_field("kana", "", decode.string)
  use avatar_url <- decode.optional_field(
    "avatar_url",
    None,
    decode.optional(decode.string),
  )
  decode.success(SpeakerData(name:, kana:, avatar_url:))
}

pub fn entry_starts_at(entry: TimetableEntry) -> String {
  case entry {
    TimeslotEntry(t) -> t.starts_at
    TalkEntry(t) -> t.starts_at
  }
}

pub fn entry_length_min(entry: TimetableEntry) -> Int {
  case entry {
    TimeslotEntry(t) -> t.length_min
    TalkEntry(t) -> t.length_min
  }
}

pub fn get_day_number(starts_at: String) -> Int {
  string.slice(starts_at, at_index: 8, length: 2)
  |> int.parse
  |> result.unwrap(0)
}

pub fn get_start_minutes(starts_at: String) -> Int {
  let hour_str = string.slice(starts_at, at_index: 11, length: 2)
  let min_str = string.slice(starts_at, at_index: 14, length: 2)
  let hour = int.parse(hour_str) |> result.unwrap(0)
  let min = int.parse(min_str) |> result.unwrap(0)
  hour * 60 + min
}

pub fn get_time_label(starts_at: String) -> String {
  string.slice(starts_at, at_index: 11, length: 5)
}
