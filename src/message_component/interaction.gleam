import gleam/dynamic.{type Dynamic}
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
    authorizing_integration_owners: List(#(String, Dynamic)),
    context: Dynamic,
    attachment_size_limit: Int,
  )
}

pub type Data {
  Button(ButtonData)
  StringSelect(StringSelectData)
  UserSelect(UserSelectData)
  RoleSelect(RoleSelectData)
  MentionableSelect(MentionableSelectData)
  ChannelSelect(ChannelSelectData)
}

pub type ButtonData {
  ButtonData(id: Int, custom_id: String)
}

pub type StringSelectData {
  StringSelectData(id: Int, custom_id: String, values: List(String))
}

pub type UserSelectData {
  UserSelectData(
    id: Int,
    custom_id: String,
    resolved: #(List(Dynamic), List(Dynamic)),
    values: List(String),
  )
}

pub type RoleSelectData {
  RoleSelectData(
    id: Int,
    custom_id: String,
    resolved: List(Dynamic),
    values: List(String),
  )
}

pub type MentionableSelectData {
  MentionableSelectData(
    id: Int,
    custom_id: String,
    resolved: #(List(Dynamic), List(Dynamic), List(Dynamic)),
    values: List(String),
  )
}

pub type ChannelSelectData {
  ChannelSelectData(
    id: Int,
    custom_id: String,
    resolved: List(Dynamic),
    values: List(String),
  )
}
