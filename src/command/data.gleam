import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option}
import resolved.{type Resolved}

pub type ChatInputData {
  ChatInputData(
    id: String,
    name: String,
    resolved: Resolved,
    options: List(Dynamic),
    guild_id: Option(String),
  )
}

pub type UserData {
  UserData(
    id: String,
    name: String,
    resolved: Resolved,
    guild_id: Option(String),
    target_id: Option(String),
  )
}

pub type MessageData {
  MessageData(
    id: String,
    name: String,
    resolved: Resolved,
    guild_id: Option(String),
    target_id: Option(String),
  )
}
