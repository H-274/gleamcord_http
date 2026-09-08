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
    1 ->
      PingInteraction(id:, application_id:, token:, version:) |> decode.success
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

pub type CommandData {
  ChatCommandData(
    id: String,
    name: String,
    resolved: Option(Dynamic),
    guild_id: Option(String),
    options: CommandOptions,
  )
  UserCommandData(
    id: String,
    name: String,
    resolved: Option(Dynamic),
    guild_id: Option(String),
    target_id: Option(String),
  )
  MessageCommandData(
    id: String,
    name: String,
    resolved: Option(Dynamic),
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
        decode.optional(decode.dynamic),
      )
      use guild_id <- decode.optional_field(
        "guild_id",
        option.None,
        decode.optional(decode.string),
      )
      use options <- decode.optional_field(
        "options",
        dict.new(),
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
        decode.optional(decode.dynamic),
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
        decode.optional(decode.dynamic),
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
          options: dict.new(),
        ),
        "CommandData",
      )
  }
}

pub type CommandOptions =
  Dict(String, Dynamic)

pub fn command_options_decoder() {
  decode.list({
    use name <- decode.field("name", decode.string)
    use value <- decode.then(decode.dynamic)
    decode.success(#(name, value))
  })
  |> decode.map(dict.from_list)
}

pub fn extract_string(opts options: CommandOptions, name name: String) {
  dict.get(options, name)
  |> result.replace_error([])
  |> result.map(decode.run(_, decode.string))
  |> result.flatten
}

pub fn extract_integer(opts options: CommandOptions, name name: String) {
  dict.get(options, name)
  |> result.replace_error([])
  |> result.map(decode.run(_, decode.int))
  |> result.flatten
}

pub fn extract_boolean(opts options: CommandOptions, name name: String) {
  dict.get(options, name)
  |> result.replace_error([])
  |> result.map(decode.run(_, decode.bool))
  |> result.flatten
}

pub fn extract_user(
  opts options: CommandOptions,
  res resolved: Dynamic,
  name name: String,
) {
  use user_id <- result.try(
    dict.get(options, name)
    |> result.replace_error([])
    |> result.map(decode.run(_, decode.string))
    |> result.flatten,
  )

  let users =
    decode.run(resolved, decode.at(["users", user_id], decode.dynamic))
  let members =
    decode.run(resolved, decode.at(["members", user_id], decode.dynamic))

  Ok(#(users, members))
}

pub fn extract_channel(
  opts options: CommandOptions,
  res resolved: Dynamic,
  name name: String,
) {
  use channel_id <- result.try(
    dict.get(options, name)
    |> result.replace_error([])
    |> result.map(decode.run(_, decode.string))
    |> result.flatten,
  )

  decode.run(resolved, decode.at(["channels", channel_id], decode.dynamic))
}

pub fn extract_role(
  opts options: CommandOptions,
  res resolved: Dynamic,
  name name: String,
) {
  use role_id <- result.try(
    dict.get(options, name)
    |> result.replace_error([])
    |> result.map(decode.run(_, decode.string))
    |> result.flatten,
  )

  decode.run(resolved, decode.at(["channels", role_id], decode.dynamic))
}

pub fn extract_mention(
  opts options: CommandOptions,
  res resolved: Dynamic,
  name name: String,
) {
  use mention_id <- result.try(
    dict.get(options, name)
    |> result.replace_error([])
    |> result.map(decode.run(_, decode.string))
    |> result.flatten,
  )

  let role =
    decode.run(resolved, decode.at(["roles", mention_id], decode.dynamic))
    |> option.from_result
  let users =
    decode.run(resolved, decode.at(["users", mention_id], decode.dynamic))
    |> option.from_result
  let members =
    decode.run(resolved, decode.at(["members", mention_id], decode.dynamic))
    |> option.from_result

  Ok(#(role, users, members))
}

pub fn extract_number(opts options: CommandOptions, name name: String) {
  dict.get(options, name)
  |> result.replace_error([])
  |> result.map(decode.run(_, decode.float))
  |> result.flatten
}

pub fn extract_attachment(
  opts options: CommandOptions,
  res resolved: Dynamic,
  name name: String,
) {
  use attachment_id <- result.try(
    dict.get(options, name)
    |> result.replace_error([])
    |> result.map(decode.run(_, decode.string))
    |> result.flatten,
  )

  decode.run(
    resolved,
    decode.at(["attachments", attachment_id], decode.dynamic),
  )
}

pub type ComponentData

pub type ModalData
