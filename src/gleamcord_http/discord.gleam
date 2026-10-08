import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option}
import gleamcord_http/locale.{type Locale}

pub type Interaction {
  ApplicationPingInteraction(PingInteraction)
  ApplicationCommandInteraction(CommandInteraction)
  ApplicationComponentInteraction(ComponentInteraction)
  ApplicationModalInteraction(ModalInteraction)
}

pub type PingInteraction {
  PingInteraction(
    id: String,
    application_id: String,
    token: String,
    version: Int,
  )
}

pub type CommandInteraction {
  CommandInteraction(
    id: String,
    application_id: String,
    data: Nil,
    guild: Option(Dynamic),
    guild_id: Option(String),
    channel: Option(Dynamic),
    channel_id: Option(String),
    member: Option(Dynamic),
    user: Option(Dynamic),
    token: String,
    version: String,
    app_permissions: String,
    locale: Option(Locale),
    guild_locale: Option(Locale),
    entitlements: List(Dynamic),
    authorizing_integration_owners: Dict(Dynamic, Dynamic),
    context: Int,
    attachment_size_limit: Int,
  )
}

pub type ComponentInteraction {
  ComponentInteraction
}

pub type ModalInteraction {
  ModalInteraction
}

pub type ValueOption {
  StringOption(name: String, value: String, focused: Bool)
  IntegerOption(name: String, value: Int, focused: Bool)
  BooleanOption(name: String, value: Bool)
  UserOption(name: String, value: String)
  ChannelOption(name: String, value: String)
  RoleOption(name: String, value: String)
  MentionableOption(name: String, value: String)
  NumberOption(name: String, value: Float, focused: Bool)
  AttachmentOption(name: String, value: String)
}

pub fn string_value(
  options: Dict(String, ValueOption),
  name: String,
) -> Result(String, Nil) {
  case dict.get(options, name) {
    Ok(StringOption(value:, ..)) -> Ok(value)
    _ -> Error(Nil)
  }
}

pub fn integer_value(
  options: Dict(String, ValueOption),
  name: String,
) -> Result(Int, Nil) {
  case dict.get(options, name) {
    Ok(IntegerOption(value:, ..)) -> Ok(value)
    _ -> Error(Nil)
  }
}

pub fn boolean_value(
  options: Dict(String, ValueOption),
  name: String,
) -> Result(Bool, Nil) {
  case dict.get(options, name) {
    Ok(BooleanOption(value:, ..)) -> Ok(value)
    _ -> Error(Nil)
  }
}

pub fn user_value(
  options: Dict(String, ValueOption),
  name: String,
) -> Result(String, Nil) {
  case dict.get(options, name) {
    Ok(UserOption(value:, ..)) -> Ok(value)
    _ -> Error(Nil)
  }
}

pub fn channel_value(
  options: Dict(String, ValueOption),
  name: String,
) -> Result(String, Nil) {
  case dict.get(options, name) {
    Ok(ChannelOption(value:, ..)) -> Ok(value)
    _ -> Error(Nil)
  }
}

pub fn role_value(
  options: Dict(String, ValueOption),
  name: String,
) -> Result(String, Nil) {
  case dict.get(options, name) {
    Ok(RoleOption(value:, ..)) -> Ok(value)
    _ -> Error(Nil)
  }
}

pub fn mentionable_value(
  options: Dict(String, ValueOption),
  name: String,
) -> Result(String, Nil) {
  case dict.get(options, name) {
    Ok(MentionableOption(value:, ..)) -> Ok(value)
    _ -> Error(Nil)
  }
}

pub fn number_value(
  options: Dict(String, ValueOption),
  name: String,
) -> Result(Float, Nil) {
  case dict.get(options, name) {
    Ok(NumberOption(value:, ..)) -> Ok(value)
    _ -> Error(Nil)
  }
}

pub fn attachment_value(
  options: Dict(String, ValueOption),
  name: String,
) -> Result(String, Nil) {
  case dict.get(options, name) {
    Ok(AttachmentOption(value:, ..)) -> Ok(value)
    _ -> Error(Nil)
  }
}
