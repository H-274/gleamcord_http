import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/option.{type Option}
import gleam/result
import gleamcord_http/locale.{type Locale}

pub type Interaction {
  PingInteraction(
    id: String,
    application_id: String,
    token: String,
    version: Int,
  )
  CommandInteraction(
    id: String,
    application_id: String,
    token: String,
    version: Int,
    data: CommandData,
    guild: Option(Dynamic),
    guild_id: Option(String),
    channel: Option(Dynamic),
    channel_id: Option(String),
    member: Option(Dynamic),
    user: Option(Dynamic),
    message: Option(Dynamic),
    app_permissions: String,
    locale: Option(Locale),
    guild_locale: Option(Locale),
    entitlements: List(Dynamic),
    auth_integ_owners: Dict(Int, String),
    context: Option(Int),
    attach_size_limit: Int,
  )
  ComponentInteraction(
    id: String,
    application_id: String,
    token: String,
    version: Int,
    data: ComponentData,
    guild: Option(Dynamic),
    guild_id: Option(String),
    channel: Option(Dynamic),
    channel_id: Option(String),
    member: Option(Dynamic),
    user: Option(Dynamic),
    message: Option(Dynamic),
    app_permissions: String,
    locale: Option(Locale),
    guild_locale: Option(Locale),
    entitlements: List(Dynamic),
    auth_integ_owners: Dict(Int, String),
    context: Option(Int),
    attach_size_limit: Int,
  )
  AutocompleteInteraction(
    id: String,
    application_id: String,
    token: String,
    version: Int,
    data: CommandData,
    guild: Option(Dynamic),
    guild_id: Option(String),
    channel: Option(Dynamic),
    channel_id: Option(String),
    member: Option(Dynamic),
    user: Option(Dynamic),
    message: Option(Dynamic),
    app_permissions: String,
    locale: Option(Locale),
    guild_locale: Option(Locale),
    entitlements: List(Dynamic),
    auth_integ_owners: Dict(Int, String),
    context: Option(Int),
    attach_size_limit: Int,
  )
  ModalInteraction(
    id: String,
    application_id: String,
    token: String,
    version: Int,
    data: ModalData,
    guild: Option(Dynamic),
    guild_id: Option(String),
    channel: Option(Dynamic),
    channel_id: Option(String),
    member: Option(Dynamic),
    user: Option(Dynamic),
    message: Option(Dynamic),
    app_permissions: String,
    locale: Option(Locale),
    guild_locale: Option(Locale),
    entitlements: List(Dynamic),
    auth_integ_owners: Dict(Int, String),
    context: Option(Int),
    attach_size_limit: Int,
  )
}

pub fn interaction_decoder() {
  use typ <- decode.field("type", decode.int)
  use id <- decode.field("id", decode.string)
  use application_id <- decode.field("application_id", decode.string)
  use token <- decode.field("token", decode.string)
  use version <- decode.field("version", decode.int)

  case typ {
    1 -> decode.success(PingInteraction(id:, application_id:, token:, version:))
    _ -> {
      use guild <- decode.optional_field(
        "guild",
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
      use message <- decode.optional_field(
        "message",
        option.None,
        decode.optional(decode.dynamic),
      )
      use app_permissions <- decode.field("app_permissions", decode.string)
      use locale <- decode.optional_field(
        "locale",
        option.None,
        decode.optional(
          decode.string
          |> decode.map(locale.from_string)
          |> decode.map(option.from_result),
        )
          |> decode.map(option.flatten),
      )
      use guild_locale <- decode.optional_field(
        "guild_locale",
        option.None,
        decode.optional(
          decode.string
          |> decode.map(locale.from_string)
          |> decode.map(option.from_result),
        )
          |> decode.map(option.flatten),
      )
      use entitlements <- decode.field(
        "entitlements",
        decode.list(decode.dynamic),
      )
      use auth_integ_owners <- decode.field(
        "authorizing_integration_owners",
        decode.dict(decode.int, decode.string),
      )
      use context <- decode.optional_field(
        "context",
        option.None,
        decode.optional(decode.int),
      )
      use attach_size_limit <- decode.field("attachment_size_limit", decode.int)
      case typ {
        2 -> {
          use data <- decode.field("data", command_data_decoder())
          CommandInteraction(
            id:,
            application_id:,
            token:,
            version:,
            data:,
            guild:,
            guild_id:,
            channel:,
            channel_id:,
            member:,
            user:,
            message:,
            app_permissions:,
            locale:,
            guild_locale:,
            entitlements:,
            auth_integ_owners:,
            context:,
            attach_size_limit:,
          )
          |> decode.success
        }
        3 -> {
          use data <- decode.field("data", todo)
          ComponentInteraction(
            id:,
            application_id:,
            token:,
            version:,
            data:,
            guild:,
            guild_id:,
            channel:,
            channel_id:,
            member:,
            user:,
            message:,
            app_permissions:,
            locale:,
            guild_locale:,
            entitlements:,
            auth_integ_owners:,
            context:,
            attach_size_limit:,
          )
          |> decode.success
        }
        4 -> {
          use data <- decode.field("data", todo)
          AutocompleteInteraction(
            id:,
            application_id:,
            token:,
            version:,
            data:,
            guild:,
            guild_id:,
            channel:,
            channel_id:,
            member:,
            user:,
            message:,
            app_permissions:,
            locale:,
            guild_locale:,
            entitlements:,
            auth_integ_owners:,
            context:,
            attach_size_limit:,
          )
          |> decode.success
        }
        5 -> {
          use data <- decode.field("data", todo)
          ModalInteraction(
            id:,
            application_id:,
            token:,
            version:,
            data:,
            guild:,
            guild_id:,
            channel:,
            channel_id:,
            member:,
            user:,
            message:,
            app_permissions:,
            locale:,
            guild_locale:,
            entitlements:,
            auth_integ_owners:,
            context:,
            attach_size_limit:,
          )
          |> decode.success
        }
        _ -> decode.failure(PingInteraction("", "", "", 0), "Interaction")
      }
    }
  }
}

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

fn resolved_decoder() -> decode.Decoder(Resolved) {
  use users <- decode.field(
    "users",
    decode.optional(decode.dict(decode.string, decode.dynamic)),
  )
  use members <- decode.field(
    "members",
    decode.optional(decode.dict(decode.string, decode.dynamic)),
  )
  use roles <- decode.field(
    "roles",
    decode.optional(decode.dict(decode.string, decode.dynamic)),
  )
  use channels <- decode.field(
    "channels",
    decode.optional(decode.dict(decode.string, decode.dynamic)),
  )
  use messages <- decode.field(
    "messages",
    decode.optional(decode.dict(decode.string, decode.dynamic)),
  )
  use attachments <- decode.field(
    "attachments",
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

pub type CommandData {
  ChatCommandData(
    id: String,
    name: String,
    resolved: Option(Resolved),
    guild_id: Option(String),
    options: CommandOptions,
  )
  UserCommandData(
    id: String,
    name: String,
    resolved: Option(Resolved),
    guild_id: Option(String),
    target_id: Option(String),
  )
  MessageCommandData(
    id: String,
    name: String,
    resolved: Option(Resolved),
    guild_id: Option(String),
    target_id: Option(String),
  )
}

pub fn command_data_decoder() {
  use variant <- decode.field("type", decode.int)
  case variant {
    1 -> {
      use id <- decode.field("id", decode.string)
      use name <- decode.field("name", decode.string)
      use resolved <- decode.optional_field(
        "resolved",
        option.None,
        decode.optional(resolved_decoder()),
      )
      use guild_id <- decode.optional_field(
        "guild_id",
        option.None,
        decode.optional(decode.string),
      )
      use options <- decode.optional_field(
        "options",
        ValueOptions(dict.new()),
        command_options_decoder(),
      )
      decode.success(ChatCommandData(id:, name:, resolved:, guild_id:, options:))
    }
    2 -> {
      use id <- decode.field("id", decode.string)
      use name <- decode.field("name", decode.string)
      use resolved <- decode.optional_field(
        "resolved",
        option.None,
        decode.optional(resolved_decoder()),
      )
      use guild_id <- decode.optional_field(
        "guild_id",
        option.None,
        decode.optional(decode.string),
      )
      use target_id <- decode.field("target_id", decode.optional(decode.string))
      decode.success(UserCommandData(
        id:,
        name:,
        resolved:,
        guild_id:,
        target_id:,
      ))
    }
    3 -> {
      use id <- decode.field("id", decode.string)
      use name <- decode.field("name", decode.string)
      use resolved <- decode.optional_field(
        "resolved",
        option.None,
        decode.optional(resolved_decoder()),
      )
      use guild_id <- decode.optional_field(
        "guild_id",
        option.None,
        decode.optional(decode.string),
      )
      use target_id <- decode.field("target_id", decode.optional(decode.string))
      decode.success(MessageCommandData(
        id:,
        name:,
        resolved:,
        guild_id:,
        target_id:,
      ))
    }
    _ ->
      decode.failure(
        ChatCommandData(
          id: "",
          name: "",
          resolved: option.None,
          guild_id: option.None,
          options: ValueOptions(dict.new()),
        ),
        "CommandData",
      )
  }
}

pub type CommandOptions {
  SubCommandGroupOption(name: String, sub_command: SubCommand)
  SubCommandOption(SubCommand)
  ValueOptions(Dict(String, ValueOption))
}

pub fn command_options_decoder() {
  use typ <- decode.field(0, decode.at(["type"], decode.int))

  case typ {
    1 ->
      decode.at([0], sub_command_decoder())
      |> decode.map(SubCommandOption)
    2 ->
      decode.at([0], {
        use name <- decode.field("name", decode.string)
        use sub_command <- decode.field("options", sub_command_decoder())
        decode.success(SubCommandGroupOption(name:, sub_command:))
      })
    3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 ->
      decode.list(value_option_decoder() |> decode.map(fn(o) { #(o.name, o) }))
      |> decode.map(dict.from_list)
      |> decode.map(ValueOptions)

    _ -> decode.failure(ValueOptions(dict.new()), "CommandOptions")
  }
}

pub type SubCommand {
  SubCommand(name: String, options: Dict(String, ValueOption))
}

fn sub_command_decoder() -> decode.Decoder(SubCommand) {
  use name <- decode.field("name", decode.string)
  use options <- decode.field(
    "options",
    decode.list(
      value_option_decoder()
      |> decode.map(fn(o) { #(o.name, o) }),
    )
      |> decode.map(dict.from_list),
  )
  decode.success(SubCommand(name:, options:))
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

pub fn value_option_decoder() -> decode.Decoder(ValueOption) {
  use variant <- decode.field("type", decode.int)
  case variant {
    3 -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.string)
      use focused <- decode.field("focused", decode.bool)
      decode.success(StringOption(name:, value:, focused:))
    }
    4 -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.int)
      use focused <- decode.field("focused", decode.bool)
      decode.success(IntegerOption(name:, value:, focused:))
    }
    5 -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.bool)
      decode.success(BooleanOption(name:, value:))
    }
    6 -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.string)
      decode.success(UserOption(name:, value:))
    }
    7 -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.string)
      decode.success(ChannelOption(name:, value:))
    }
    8 -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.string)
      decode.success(RoleOption(name:, value:))
    }
    9 -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.string)
      decode.success(MentionableOption(name:, value:))
    }
    10 -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.float)
      use focused <- decode.field("focused", decode.bool)
      decode.success(NumberOption(name:, value:, focused:))
    }
    11 -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.string)
      decode.success(AttachmentOption(name:, value:))
    }
    _ -> decode.failure(BooleanOption(name: "", value: False), "ValueOption")
  }
}

pub fn options_string(
  options: Dict(String, ValueOption),
  key: String,
) -> Result(String, Nil) {
  use option <- result.try(dict.get(options, key))
  case option {
    StringOption(value:, ..) -> Ok(value)
    _ -> Error(Nil)
  }
}

pub fn options_integer(
  options: Dict(String, ValueOption),
  key: String,
) -> Result(Int, Nil) {
  use option <- result.try(dict.get(options, key))
  case option {
    IntegerOption(value:, ..) -> Ok(value)
    _ -> Error(Nil)
  }
}

pub fn options_boolean(
  options: Dict(String, ValueOption),
  key: String,
) -> Result(Bool, Nil) {
  use option <- result.try(dict.get(options, key))
  case option {
    BooleanOption(value:, ..) -> Ok(value)
    _ -> Error(Nil)
  }
}

/// Tuple options are: user, member
pub fn options_user(
  options: Dict(String, ValueOption),
  key: String,
  resolved: Resolved,
) -> Result(#(Option(Dynamic), Option(Dynamic)), Nil) {
  use snowflake <- result.try(options_user_id(options, key))
  let user =
    resolved.users
    |> option.map(dict.get(_, snowflake))
    |> option.map(option.from_result)
    |> option.flatten
  let member =
    resolved.members
    |> option.map(dict.get(_, snowflake))
    |> option.map(option.from_result)
    |> option.flatten

  Ok(#(user, member))
}

pub fn options_user_id(
  options: Dict(String, ValueOption),
  key: String,
) -> Result(String, Nil) {
  use option <- result.try(dict.get(options, key))
  case option {
    UserOption(value:, ..) -> Ok(value)
    _ -> Error(Nil)
  }
}

pub fn options_channel(
  options: Dict(String, ValueOption),
  key: String,
  resolved: Resolved,
) -> Result(Dynamic, Nil) {
  use snowflake <- result.try(options_channel_id(options, key))
  case resolved.channels {
    option.Some(channels) -> dict.get(channels, snowflake)
    _ -> Error(Nil)
  }
}

pub fn options_channel_id(
  options: Dict(String, ValueOption),
  key: String,
) -> Result(String, Nil) {
  use option <- result.try(dict.get(options, key))
  case option {
    ChannelOption(value:, ..) -> Ok(value)
    _ -> Error(Nil)
  }
}

pub fn options_role(
  options: Dict(String, ValueOption),
  key: String,
  resolved: Resolved,
) -> Result(Dynamic, Nil) {
  use snowflake <- result.try(options_role_id(options, key))
  case resolved.roles {
    option.Some(roles) -> dict.get(roles, snowflake)
    _ -> Error(Nil)
  }
}

pub fn options_role_id(
  options: Dict(String, ValueOption),
  key: String,
) -> Result(String, Nil) {
  use option <- result.try(dict.get(options, key))
  case option {
    RoleOption(value:, ..) -> Ok(value)
    _ -> Error(Nil)
  }
}

/// Tuple options are: user, member, role
pub fn options_mentionable(
  options: Dict(String, ValueOption),
  key: String,
  resolved: Resolved,
) -> Result(#(Option(Dynamic), Option(Dynamic), Option(Dynamic)), Nil) {
  use snowflake <- result.try(options_mentionable_id(options, key))
  let user =
    resolved.users
    |> option.map(dict.get(_, snowflake))
    |> option.map(option.from_result)
    |> option.flatten
  let member =
    resolved.members
    |> option.map(dict.get(_, snowflake))
    |> option.map(option.from_result)
    |> option.flatten
  let role =
    resolved.roles
    |> option.map(dict.get(_, snowflake))
    |> option.map(option.from_result)
    |> option.flatten

  Ok(#(user, member, role))
}

pub fn options_mentionable_id(
  options: Dict(String, ValueOption),
  key: String,
) -> Result(String, Nil) {
  use option <- result.try(dict.get(options, key))
  case option {
    MentionableOption(value:, ..) -> Ok(value)
    _ -> Error(Nil)
  }
}

pub fn options_number(
  options: Dict(String, ValueOption),
  key: String,
) -> Result(Float, Nil) {
  use option <- result.try(dict.get(options, key))
  case option {
    NumberOption(value:, ..) -> Ok(value)
    _ -> Error(Nil)
  }
}

pub fn options_attachment(
  options: Dict(String, ValueOption),
  key: String,
  resolved: Resolved,
) -> Result(Dynamic, Nil) {
  use snowflake <- result.try(options_attachment_id(options, key))
  case resolved.attachments {
    option.Some(channels) -> dict.get(channels, snowflake)
    _ -> Error(Nil)
  }
}

pub fn options_attachment_id(
  options: Dict(String, ValueOption),
  key: String,
) -> Result(String, Nil) {
  use option <- result.try(dict.get(options, key))
  case option {
    AttachmentOption(value:, ..) -> Ok(value)
    _ -> Error(Nil)
  }
}

pub type ComponentData

pub type ModalData
