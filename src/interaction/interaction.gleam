import application_command/interaction.{type Interaction as CommandInteraction}
import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option}
import interaction/data
import locale.{type Locale}

pub type Interaction {
  Ping(id: String, application_id: String, token: String, version: Int)
  ApplicationCommand(CommandInteraction)
  MessageComponent(
    id: String,
    application_id: String,
    data: data.MessageComponent,
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
  ApplicationCommandAutocomplete(CommandInteraction)
  ModalSubmit(
    id: String,
    application_id: String,
    data: data.ModalSubmit,
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
