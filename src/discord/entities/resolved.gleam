import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/option.{type Option}

/// TODO use proper entities when they exist
pub type Resolved {
  Resolved(
    users: Option(Dict(String, Dynamic)),
    members: Option(Dict(String, Dynamic)),
    roles: Option(Dict(String, Dynamic)),
    channels: Option(Dict(String, Dynamic)),
    messages: Option(Dict(String, Dynamic)),
    attachments: Option(Dict(String, Dynamic)),
  )
}

pub fn resolved_decoder() -> decode.Decoder(Resolved) {
  use users <- decode.optional_field(
    "users",
    option.None,
    decode.optional(decode.dict(decode.string, decode.dynamic)),
  )
  use members <- decode.optional_field(
    "members",
    option.None,
    decode.optional(decode.dict(decode.string, decode.dynamic)),
  )
  use roles <- decode.optional_field(
    "roles",
    option.None,
    decode.optional(decode.dict(decode.string, decode.dynamic)),
  )
  use channels <- decode.optional_field(
    "channels",
    option.None,
    decode.optional(decode.dict(decode.string, decode.dynamic)),
  )
  use messages <- decode.optional_field(
    "messages",
    option.None,
    decode.optional(decode.dict(decode.string, decode.dynamic)),
  )
  use attachments <- decode.optional_field(
    "attachments",
    option.None,
    decode.optional(decode.dict(decode.string, decode.dynamic)),
  )
  decode.success(Resolved(
    users:,
    members:,
    roles:,
    channels:,
    messages:,
    attachments:,
  ))
}
