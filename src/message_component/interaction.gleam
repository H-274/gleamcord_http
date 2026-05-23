import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/option.{type Option}
import locale.{type Locale}

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
    message: Dynamic,
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
  use message <- decode.field("message", decode.dynamic)
  use permissions <- decode.field("app_permissions", decode.string)
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
  Button(ButtonData)
  StringSelect(StringSelectData)
  UserSelect(UserSelectData)
  RoleSelect(RoleSelectData)
  MentionableSelect(MentionableSelectData)
  ChannelSelect(ChannelSelectData)
}

fn data_decoder() -> decode.Decoder(Data) {
  use t <- decode.field("component_type", decode.int)
  case t {
    2 -> button_data_decoder() |> decode.map(Button)
    3 -> string_select_data_decoder() |> decode.map(StringSelect)
    5 -> user_select_data_decoder() |> decode.map(UserSelect)
    6 -> role_select_data_decoder() |> decode.map(RoleSelect)
    7 -> mentionable_select_data_decoder() |> decode.map(MentionableSelect)
    8 -> channel_select_data_decoder() |> decode.map(ChannelSelect)
    _ -> decode.failure(Button(ButtonData(0, "")), "Data")
  }
}

pub type ButtonData {
  ButtonData(id: Int, custom_id: String)
}

fn button_data_decoder() -> decode.Decoder(ButtonData) {
  use id <- decode.field("id", decode.int)
  use custom_id <- decode.field("custom_id", decode.string)

  ButtonData(id:, custom_id:)
  |> decode.success
}

pub type StringSelectData {
  StringSelectData(id: Int, custom_id: String, values: List(String))
}

fn string_select_data_decoder() -> decode.Decoder(StringSelectData) {
  todo
}

// TODO update values type
pub type UserSelectData {
  UserSelectData(
    id: Int,
    custom_id: String,
    resolved: #(List(Dynamic), List(Dynamic)),
    values: List(String),
  )
}

fn user_select_data_decoder() -> decode.Decoder(UserSelectData) {
  todo
}

pub type RoleSelectData {
  RoleSelectData(
    id: Int,
    custom_id: String,
    resolved: List(Dynamic),
    values: List(String),
  )
}

fn role_select_data_decoder() -> decode.Decoder(RoleSelectData) {
  todo
}

pub type MentionableSelectData {
  MentionableSelectData(
    id: Int,
    custom_id: String,
    resolved: #(List(Dynamic), List(Dynamic), List(Dynamic)),
    values: List(String),
  )
}

fn mentionable_select_data_decoder() -> decode.Decoder(MentionableSelectData) {
  todo
}

pub type ChannelSelectData {
  ChannelSelectData(
    id: Int,
    custom_id: String,
    resolved: List(Dynamic),
    values: List(String),
  )
}

fn channel_select_data_decoder() -> decode.Decoder(ChannelSelectData) {
  todo
}
