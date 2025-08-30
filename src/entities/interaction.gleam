import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/option.{type Option}

pub type Interaction {
  Interaction(
    id: String,
    type_: Type,
    application_id: String,
    data: Option(Dynamic),
    guild: Option(Dynamic),
    guild_id: Option(String),
    channel: Option(Dynamic),
    channel_id: Option(String),
    member: Option(Dynamic),
    user: Option(Dynamic),
    token: String,
    version: Int,
    message: Option(Dynamic),
    app_permissions: String,
    locale: Option(String),
    guild_locale: Option(String),
    entitlements: List(Dynamic),
    authorizing_integration_owners: List(Dynamic),
    context: Option(Dynamic),
    attachment_size_limit: Int,
  )
}

pub fn decoder() -> decode.Decoder(Interaction) {
  use id <- decode.field("id", decode.string)
  use type_ <- decode.field("type", type_decoder())
  use application_id <- decode.field("application_id", decode.string)
  use data <- decode.optional_field(
    "data",
    option.None,
    decode.optional(decode.dynamic),
  )
  use guild <- decode.optional_field(
    ["guild"],
    option.None,
    decode.optional(decode.dynamic),
  )
  use guild_id <- decode.optional_field(
    "guild_id",
    option.None,
    decode.optional(decode.string),
  )
  use channel <- decode.optional_field(
    "channel",
    option.None,
    decode.optional(decode.dynamic),
  )
  use channel_id <- decode.optional_field(
    "channel_id",
    option.None,
    decode.optional(decode.string),
  )
  use member <- decode.optional_field(
    "member",
    option.None,
    decode.optional(decode.dynamic),
  )
  use user <- decode.optional_field(
    "user",
    option.None,
    decode.optional(decode.dynamic),
  )
  use token <- decode.field("token", decode.string)
  use version <- decode.field("version", decode.int)
  use message <- decode.optional_field(
    "message",
    option.None,
    decode.optional(decode.dynamic),
  )
  use app_permissions <- decode.field("app_permissions", decode.string)
  use locale <- decode.optional_field(
    "locale",
    option.None,
    decode.optional(decode.string),
  )
  use guild_locale <- decode.optional_field(
    "guild_locale",
    option.None,
    decode.optional(decode.string),
  )
  use entitlements <- decode.field("entitlements", decode.list(decode.dynamic))
  use authorizing_integration_owners <- decode.field(
    "authorizing_integration_owners",
    decode.list(decode.dynamic),
  )
  use context <- decode.optional_field(
    "context",
    option.None,
    decode.optional(decode.dynamic),
  )
  use attachment_size_limit <- decode.field("attachment_size_limit", decode.int)

  decode.success(Interaction(
    id:,
    type_:,
    application_id:,
    data:,
    guild:,
    guild_id:,
    channel:,
    channel_id:,
    member:,
    user:,
    token:,
    version:,
    message:,
    app_permissions:,
    locale:,
    guild_locale:,
    entitlements:,
    authorizing_integration_owners:,
    context:,
    attachment_size_limit:,
  ))
}

pub type Type {
  Ping
  ApplicationCommand
  ApplicationCommandAutocomplete
  MessageComponent
  ModalSubmit
}

fn type_decoder() {
  use type_string <- decode.then(decode.int)
  case type_string {
    1 -> decode.success(Ping)
    2 -> decode.success(ApplicationCommand)
    3 -> decode.success(MessageComponent)
    4 -> decode.success(ApplicationCommandAutocomplete)
    5 -> decode.success(ModalSubmit)
    _ -> decode.failure(Ping, "entities/interaction.Type")
  }
}
