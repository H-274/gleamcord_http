import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/option.{type Option}
import gleamcord_http/locale.{type Locale}

pub type Interaction {
  PingInteraction(
    id: String,
    application_id: String,
    token: String,
    version: Int,
  )
  CommandInteraction(CommandInteraction)
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
    app_permissions: Option(String),
    locale: Option(Locale),
    guild_locale: Option(Locale),
    entitlements: List(Dynamic),
    auth_integ_owners: Dict(Dynamic, Dynamic),
    context: Int,
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
    app_permissions: Option(String),
    locale: Option(Locale),
    guild_locale: Option(Locale),
    entitlements: List(Dynamic),
    auth_integ_owners: Dict(Dynamic, Dynamic),
    context: Int,
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
    app_permissions: Option(String),
    locale: Option(Locale),
    guild_locale: Option(Locale),
    entitlements: List(Dynamic),
    auth_integ_owners: Dict(Dynamic, Dynamic),
    context: Int,
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
    2 -> {
      use data <- decode.field("data", todo)
      CommandInteractionVariant(
        id:,
        application_id:,
        token:,
        version:,
        data:,
        guild: todo,
        guild_id: todo,
        channel: todo,
        channel_id: todo,
        member: todo,
        user: todo,
        message: todo,
        app_permissions: todo,
        locale: todo,
        guild_locale: todo,
        entitlements: todo,
        auth_integ_owners: todo,
        context: todo,
        attach_size_limit: todo,
      )
      |> CommandInteraction
      |> decode.success
    }
    3 -> todo
    4 -> todo
    5 -> todo
    _ -> decode.failure(PingInteraction("", "", "", 0), "Interaction")
  }
}

pub type CommandInteraction {
  CommandInteractionVariant(
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
    app_permissions: Option(String),
    locale: Option(Locale),
    guild_locale: Option(Locale),
    entitlements: List(Dynamic),
    auth_integ_owners: Dict(Dynamic, Dynamic),
    context: Int,
    attach_size_limit: Int,
  )
}

pub type CommandData

pub type ComponentData

pub type ModalData
