import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/option.{type Option}

pub type Resolved {
  Resolved(
    users: Option(List(#(String, Dynamic))),
    members: Option(List(#(String, Dynamic))),
    roles: Option(List(#(String, Dynamic))),
    channels: Option(List(#(String, Dynamic))),
    messages: Option(List(#(String, Dynamic))),
    attachments: Option(List(#(String, Dynamic))),
  )
}

pub fn decoder() -> decode.Decoder(Resolved) {
  use users <- decode.optional_field(
    "users",
    option.None,
    decode.optional(
      decode.list({
        use a <- decode.field(0, decode.string)
        use b <- decode.field(1, decode.dynamic)

        decode.success(#(a, b))
      }),
    ),
  )
  use members <- decode.optional_field(
    "members",
    option.None,
    decode.optional(
      decode.list({
        use a <- decode.field(0, decode.string)
        use b <- decode.field(1, decode.dynamic)

        decode.success(#(a, b))
      }),
    ),
  )
  use roles <- decode.optional_field(
    "roles",
    option.None,
    decode.optional(
      decode.list({
        use a <- decode.field(0, decode.string)
        use b <- decode.field(1, decode.dynamic)

        decode.success(#(a, b))
      }),
    ),
  )
  use channels <- decode.optional_field(
    "channels",
    option.None,
    decode.optional(
      decode.list({
        use a <- decode.field(0, decode.string)
        use b <- decode.field(1, decode.dynamic)

        decode.success(#(a, b))
      }),
    ),
  )
  use messages <- decode.optional_field(
    "messages",
    option.None,
    decode.optional(
      decode.list({
        use a <- decode.field(0, decode.string)
        use b <- decode.field(1, decode.dynamic)

        decode.success(#(a, b))
      }),
    ),
  )
  use attachments <- decode.optional_field(
    "attachments",
    option.None,
    decode.optional(
      decode.list({
        use a <- decode.field(0, decode.string)
        use b <- decode.field(1, decode.dynamic)

        decode.success(#(a, b))
      }),
    ),
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
