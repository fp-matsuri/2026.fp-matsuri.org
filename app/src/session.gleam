import gleam/dynamic/decode
import gleam/json
import gleam/option.{type Option, None}
import gleam/result
import simplifile

pub type Session {
  Session(url: String, title: String, speaker: Speaker, tags: List(SessionTag))
}

pub type Speaker {
  Speaker(name: String, kana: String, avatar_url: Option(String))
}

pub type SessionTag {
  SessionTag(name: String)
}

const sessions_file_path = "../content/sessions.json"

pub fn load_sessions() -> Result(List(Session), String) {
  {
    use content <- result.try(
      simplifile.read(sessions_file_path)
      |> result.replace_error("sessions.json を読み込めませんでした"),
    )
    use sessions <- result.try(
      case json.parse(content, decode.list(session_decoder())) {
        Ok(items) -> Ok(items)
        Error(_) -> Error("sessions.json を decode できませんでした")
      },
    )
    Ok(sessions)
  }
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
