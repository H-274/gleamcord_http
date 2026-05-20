import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/option.{type Option}
import locale.{type Locale}
import resolved.{type Resolved}

pub type Interaction {
  Interaction(
    id: String,
    application_id: String,
    data: Data,
    guild: Option(Dynamic),
    guild_id: Option(String),
    channel: Option(Dynamic),
    channel_id: Option(String),
    member: Option(Dynamic),
    user: Option(Dynamic),
    token: String,
    version: Int,
    message: Option(Dynamic),
    permissions: String,
    locale: Option(Locale),
    guild_locale: Option(Locale),
    entitlements: List(Dynamic),
    authorizing_integration_owners: Dict(String, Dynamic),
    context: Dynamic,
    attachment_size_limit: Int,
  )
}

pub fn decoder() -> decode.Decoder(Interaction) {
  use id <- decode.field("id", decode.string)
  use application_id <- decode.field("application_id", decode.string)
  use data <- decode.field("data", data_decoder())
  use guild <- decode.field("guild", decode.optional(decode.dynamic))
  use guild_id <- decode.field("guild_id", decode.optional(decode.string))
  use channel <- decode.field("channel", decode.optional(decode.dynamic))
  use channel_id <- decode.field("channel_id", decode.optional(decode.string))
  use member <- decode.field("member", decode.optional(decode.dynamic))
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
  use permissions <- decode.optional_field("app_permissions", "", decode.string)
  use locale <- decode.field("locale", decode.optional(locale.decoder()))
  use guild_locale <- decode.field(
    "guild_locale",
    decode.optional(locale.decoder()),
  )
  use entitlements <- decode.field("entitlements", decode.list(decode.dynamic))
  use authorizing_integration_owners <- decode.field(
    "authorizing_integration_owners",
    decode.dict(decode.string, decode.dynamic),
  )
  use context <- decode.field("context", decode.dynamic)
  use attachment_size_limit <- decode.field("attachment_size_limit", decode.int)
  decode.success(Interaction(
    id:,
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
    permissions:,
    locale:,
    guild_locale:,
    entitlements:,
    authorizing_integration_owners:,
    context:,
    attachment_size_limit:,
  ))
}

pub type Data {
  Data(
    custom_id: String,
    components: Dict(String, String),
    resolved: Option(Resolved),
  )
}

fn data_decoder() -> decode.Decoder(Data) {
  use custom_id <- decode.field("custom_id", decode.string)
  use components <- decode.field(
    "components",
    decode.list({
      use custom_id <- decode.subfield(
        ["component", "custom_id"],
        decode.string,
      )
      use value <- decode.subfield(["component", "value"], decode.string)
      decode.success(#(custom_id, value))
    })
      |> decode.map(dict.from_list),
  )
  use resolved <- decode.optional_field(
    "resolved",
    option.None,
    decode.optional(resolved.decoder()),
  )
  decode.success(Data(custom_id:, components:, resolved:))
}
