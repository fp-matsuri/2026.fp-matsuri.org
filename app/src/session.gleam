import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/http/request
import gleam/httpc
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string

pub type Session {
  Session(
    url: String,
    title: String,
    speaker: Speaker,
    tags: List(SessionTag),
  )
}

pub type Speaker {
  Speaker(
    name: String,
    kana: String,
    avatar_url: Option(String),
  )
}

pub type SessionTag {
  SessionTag(name: String)
}

const timetable_url = "https://fortee.jp/2026fp-matsuri/api/timetable"

pub fn load_sessions() -> Result(List(Session), String) {
  {
    use content <- result.try(load_schedule_json())
    use sessions <- result.try(
      case json.parse(content, schedule_decoder()) {
        Ok(items) -> Ok(items)
        Error(_) -> Error("fortee API のレスポンスを decode できませんでした")
      },
    )
    Ok(sessions)
  }
}

fn load_schedule_json() -> Result(String, String) {
  let request =
    case request.to(timetable_url) {
      Ok(req) -> req
      Error(_) -> panic as "fortee timetable URL が不正です"
    }

  case httpc.send(request) {
    Ok(response) -> Ok(response.body)
    Error(error) ->
      Error("fortee API の取得に失敗しました: " <> string.inspect(error))
  }
}

fn schedule_decoder() -> decode.Decoder(List(Session)) {
  use timetable <- decode.field("timetable", decode.list(decode.dynamic))
  decode.success(timetable |> list.map(decode_session) |> option.values)
}

fn decode_session(item: Dynamic) -> Option(Session) {
  case decode.run(item, accepted_decoder()) {
    Ok(True) ->
      case decode.run(item, session_decoder()) {
        Ok(session) -> Some(session)
        Error(_) -> None
      }

    Ok(False) -> None
    Error(_) -> None
  }
}

fn accepted_decoder() -> decode.Decoder(Bool) {
  use accepted <- decode.field("accepted", decode.bool)
  decode.success(accepted)
}

fn session_decoder() -> decode.Decoder(Session) {
  use url <- decode.field("url", decode.string)
  use title <- decode.field("title", decode.string)
  use speaker <- decode.field("speaker", speaker_decoder())
  use tags <- decode.field("tags", decode.list(tag_decoder()))
  decode.success(Session(url:, title:, speaker:, tags:))
}

fn speaker_decoder() -> decode.Decoder(Speaker) {
  use name <- decode.field("name", decode.string)
  use kana <- decode.field("kana", decode.string)
  use avatar_url <- decode.optional_field(
    "avatar_url",
    None,
    decode.optional(decode.string),
  )
  decode.success(Speaker(name:, kana:, avatar_url:))
}

fn tag_decoder() -> decode.Decoder(SessionTag) {
  use name <- decode.field("name", decode.string)
  decode.success(SessionTag(name:))
}
