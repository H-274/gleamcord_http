import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/option.{type Option}
import gleamcord_http/locale.{type Locale}

pub type Interaction {
  ApplicationPingInteraction(PingInteraction)
  ApplicationCommandInteraction(CommandInteraction)
  ApplicationComponentInteraction(ComponentInteraction)
  ApplicationAutocompleteInteraction(CommandInteraction)
  ApplicationModalInteraction(ModalInteraction)
}

pub fn interaction_decoder() {
  use typ <- decode.field("type", decode.int)
  case typ {
    1 -> ping_interaction_decoder() |> decode.map(ApplicationPingInteraction)
    2 ->
      command_interaction_decoder() |> decode.map(ApplicationCommandInteraction)
    3 -> todo |> decode.map(ApplicationComponentInteraction)
    4 ->
      command_interaction_decoder()
      |> decode.map(ApplicationAutocompleteInteraction)
    5 -> todo |> decode.map(ApplicationModalInteraction)
    _ ->
      decode.failure(
        PingInteraction(id: "", application_id: "", token: "", version: -1)
          |> ApplicationPingInteraction,
        "Interaction",
      )
  }
}

pub type PingInteraction {
  PingInteraction(
    id: String,
    application_id: String,
    token: String,
    version: Int,
  )
}

fn ping_interaction_decoder() -> decode.Decoder(PingInteraction) {
  use id <- decode.field("id", decode.string)
  use application_id <- decode.field("application_id", decode.string)
  use token <- decode.field("token", decode.string)
  use version <- decode.field("version", decode.int)

  decode.success(PingInteraction(id:, application_id:, token:, version:))
}

pub type CommandInteraction {
  CommandInteraction(
    id: String,
    application_id: String,
    data: CommandInteractionData,
    guild: Option(Dynamic),
    guild_id: Option(String),
    channel: Option(Dynamic),
    channel_id: Option(String),
    member: Option(Dynamic),
    user: Option(Dynamic),
    token: String,
    version: Int,
    app_permissions: String,
    locale: Option(Locale),
    guild_locale: Option(Locale),
    entitlements: List(Dynamic),
    authorizing_integration_owners: Dict(Int, String),
    context: Int,
    attachment_size_limit: Int,
  )
}

fn command_interaction_decoder() {
  use id <- decode.field("id", decode.string)
  use application_id <- decode.field("application_id", decode.string)
  use data <- decode.field("data", command_interaction_data_decoder())
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
  use token <- decode.field("token", decode.string)
  use version <- decode.field("version", decode.int)
  use app_permissions <- decode.field("application_permissions", decode.string)
  use locale <- decode.optional_field(
    "locale",
    option.None,
    decode.optional(locale.decoder()),
  )
  use guild_locale <- decode.optional_field(
    "guild_locale",
    option.None,
    decode.optional(locale.decoder()),
  )
  use entitlements <- decode.field("entitlements", decode.list(decode.dynamic))
  use authorizing_integration_owners <- decode.field(
    "authorizing_integration_owners",
    decode.dict(decode.int, decode.string),
  )
  use context <- decode.field("context", decode.int)
  use attachment_size_limit <- decode.field("attachment_size_limit", decode.int)

  decode.success(CommandInteraction(
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
    app_permissions:,
    locale:,
    guild_locale:,
    entitlements:,
    authorizing_integration_owners:,
    context:,
    attachment_size_limit:,
  ))
}

pub type CommandInteractionData {
  ChatCommandData(
    id: String,
    name: String,
    resolved: Resolved,
    options: CommandOptions,
    guild_id: Option(String),
  )
  MessageCommandData(
    id: String,
    name: String,
    resolved: Resolved,
    guild_id: Option(String),
    target_id: String,
  )
  UserCommandData(
    id: String,
    name: String,
    resolved: Resolved,
    guild_id: Option(String),
    target_id: String,
  )
}

fn command_interaction_data_decoder() {
  use typ <- decode.field("type", decode.int)
  use id <- decode.field("id", decode.string)
  use name <- decode.field("name", decode.string)
  use resolved <- decode.optional_field(
    "resolved",
    empty_resolved(),
    resolved_decoder(),
  )
  use guild_id <- decode.optional_field(
    "guild_id",
    option.None,
    decode.optional(decode.string),
  )

  case typ {
    1 ->
      decode.at(
        ["options"],
        command_options_decoder()
          |> decode.map(ChatCommandData(
            id:,
            name:,
            resolved:,
            options: _,
            guild_id:,
          )),
      )
    2 ->
      decode.at(["target_id"], decode.string)
      |> decode.map(MessageCommandData(
        id:,
        name:,
        resolved:,
        guild_id:,
        target_id: _,
      ))
    3 ->
      decode.at(["target_id"], decode.string)
      |> decode.map(UserCommandData(
        id:,
        name:,
        resolved:,
        guild_id:,
        target_id: _,
      ))
    _ ->
      decode.failure(
        ChatCommandData("", "", empty_resolved(), ValueOptions([]), option.None),
        "CommandInteractionData",
      )
  }
}

pub type CommandOptions {
  SubCommandGroupOption(name: String, options: SubCommand)
  SubCommandOption(SubCommand)
  ValueOptions(List(ValueOption))
}

pub fn command_options_decoder() {
  use first_type <- decode.field(0, decode.at(["type"], decode.int))
  case first_type {
    1 ->
      decode.at([0], {
        sub_command_decoder()
        |> decode.map(SubCommandOption)
      })
    2 ->
      decode.at([0], {
        use name <- decode.field("name", decode.string)
        use options <- decode.field("options", sub_command_decoder())
        decode.success(SubCommandGroupOption(name:, options:))
      })
    3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 ->
      decode.list(value_option_decoder())
      |> decode.map(ValueOptions)
    _ -> decode.failure(ValueOptions([]), "CommandOptions")
  }
}

pub type SubCommand {
  SubCommand(name: String, options: List(ValueOption))
}

fn sub_command_decoder() -> decode.Decoder(SubCommand) {
  use name <- decode.field("name", decode.string)
  use options <- decode.field("options", decode.list(value_option_decoder()))
  decode.success(SubCommand(name:, options:))
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

fn value_option_decoder() -> decode.Decoder(ValueOption) {
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

pub type Resolved {
  Resolved(
    users: Dict(String, Dynamic),
    members: Dict(String, Dynamic),
    roles: Dict(String, Dynamic),
    channels: Dict(String, Dynamic),
    messages: Dict(String, Dynamic),
    attachments: Dict(String, Dynamic),
  )
}

pub fn empty_resolved() {
  Resolved(
    users: dict.new(),
    members: dict.new(),
    roles: dict.new(),
    channels: dict.new(),
    messages: dict.new(),
    attachments: dict.new(),
  )
}

fn resolved_decoder() -> decode.Decoder(Resolved) {
  use users <- decode.optional_field(
    "users",
    dict.new(),
    decode.dict(decode.string, decode.dynamic),
  )
  use members <- decode.optional_field(
    "members",
    dict.new(),
    decode.dict(decode.string, decode.dynamic),
  )
  use roles <- decode.optional_field(
    "roles",
    dict.new(),
    decode.dict(decode.string, decode.dynamic),
  )
  use channels <- decode.optional_field(
    "channels",
    dict.new(),
    decode.dict(decode.string, decode.dynamic),
  )
  use messages <- decode.optional_field(
    "messages",
    dict.new(),
    decode.dict(decode.string, decode.dynamic),
  )
  use attachments <- decode.optional_field(
    "attachments",
    dict.new(),
    decode.dict(decode.string, decode.dynamic),
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
