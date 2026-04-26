//// Based on:
//// - https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object

import command/option_value.{type OptionValue}
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
    permissions: String,
    locale: Option(Locale),
    guild_locale: Option(Locale),
    entitlements: List(Dynamic),
    authorizing_integration_owners: List(#(String, Dynamic)),
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
  use user <- decode.field("user", decode.optional(decode.dynamic))
  use token <- decode.field("token", decode.string)
  use version <- decode.field("version", decode.int)
  use permissions <- decode.field("permissions", decode.string)
  use locale <- decode.field("locale", decode.optional(locale.decoder()))
  use guild_locale <- decode.field(
    "guild_locale",
    decode.optional(locale.decoder()),
  )
  use entitlements <- decode.field("entitlements", decode.list(decode.dynamic))
  use authorizing_integration_owners <- decode.field(
    "authorizing_integration_owners",
    decode.list({
      use a <- decode.field(0, decode.string)
      use b <- decode.field(1, decode.dynamic)

      decode.success(#(a, b))
    }),
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
  ChatInput(ChatInputData)
  User(UserData)
  Message(MessageData)
}

fn data_decoder() -> decode.Decoder(Data) {
  decode.one_of(chat_input_data_decoder() |> decode.map(ChatInput), [
    user_data_decoder() |> decode.map(User),
    message_data_decoder() |> decode.map(Message),
  ])
}

pub type ChatInputData {
  ChatInputData(
    id: String,
    name: String,
    resolved: Resolved,
    options: OptionValue,
    guild_id: Option(String),
    target_id: Option(String),
  )
}

fn chat_input_data_decoder() -> decode.Decoder(ChatInputData) {
  use id <- decode.field("id", decode.string)
  use name <- decode.field("name", decode.string)
  use resolved <- decode.field("resolved", resolved.decoder())
  use options <- decode.field("options", option_value.decoder())
  use guild_id <- decode.field("guild_id", decode.optional(decode.string))
  use target_id <- decode.field("target_id", decode.optional(decode.string))
  decode.success(ChatInputData(
    id:,
    name:,
    resolved:,
    options:,
    guild_id:,
    target_id:,
  ))
}

pub type UserData {
  UserData(
    id: String,
    name: String,
    resolved: Resolved,
    guild_id: Option(String),
    target_id: String,
  )
}

fn user_data_decoder() -> decode.Decoder(UserData) {
  use id <- decode.field("id", decode.string)
  use name <- decode.field("name", decode.string)
  use resolved <- decode.field("resolved", resolved.decoder())
  use guild_id <- decode.field("guild_id", decode.optional(decode.string))
  use target_id <- decode.field("target_id", decode.string)
  decode.success(UserData(id:, name:, resolved:, guild_id:, target_id:))
}

pub type MessageData {
  MessageData(
    id: String,
    name: String,
    resolved: Resolved,
    guild_id: Option(String),
    target_id: String,
  )
}

fn message_data_decoder() -> decode.Decoder(MessageData) {
  use id <- decode.field("id", decode.string)
  use name <- decode.field("name", decode.string)
  use resolved <- decode.field("resolved", resolved.decoder())
  use guild_id <- decode.field("guild_id", decode.optional(decode.string))
  use target_id <- decode.field("target_id", decode.string)
  decode.success(MessageData(id:, name:, resolved:, guild_id:, target_id:))
}
