//// Based on:
//// - https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object

import application_command/option_value.{type OptionValue}
import gleam/dynamic.{type Dynamic}
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

pub type Data {
  ChatInput(ChatInputData)
  User(UserData)
  Message(MessageData)
}

pub type ChatInputData {
  ChatInputData(
    id: String,
    name: String,
    resolved: Option(Resolved),
    options: OptionValue,
    guild_id: Option(String),
    target_id: Option(String),
  )
}

pub type UserData {
  UserData(
    id: String,
    name: String,
    resolved: Option(Resolved),
    guild_id: Option(String),
    target_id: Option(String),
  )
}

pub type MessageData {
  MessageData(
    id: String,
    name: String,
    resolved: Option(Resolved),
    guild_id: Option(String),
    target_id: Option(String),
  )
}
