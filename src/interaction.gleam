import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/option.{type Option}
import interaction/data
import locale.{type Locale}

pub type Interaction {
  Ping(id: String, application_id: String, token: String, version: Int)
  ApplicationCommand(
    id: String,
    application_id: String,
    data: data.ApplicationCommand,
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
  ApplicationCommandAutocomplete(
    id: String,
    application_id: String,
    data: data.ApplicationCommand,
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

pub fn decoder() -> decode.Decoder(Interaction) {
  use variant <- decode.field("type", decode.string)
  case variant {
    "1" -> {
      use id <- decode.field("id", decode.string)
      use application_id <- decode.field("application_id", decode.string)
      use token <- decode.field("token", decode.string)
      use version <- decode.field("version", decode.int)
      decode.success(Ping(id:, application_id:, token:, version:))
    }
    "2" -> {
      use id <- decode.field("id", decode.string)
      use application_id <- decode.field("application_id", decode.string)
      use data <- decode.field("data", data.application_command_decoder())
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
      use permissions <- decode.field("permissions", decode.string)
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
      use entitlements <- decode.field(
        "entitlements",
        decode.list(decode.dynamic),
      )
      use authorizing_integration_owners <- decode.field(
        "authorizing_integration_owners",
        decode.list({
          use a <- decode.field(0, decode.string)
          use b <- decode.field(1, decode.dynamic)

          decode.success(#(a, b))
        }),
      )
      use context <- decode.field("context", decode.dynamic)
      use attachment_size_limit <- decode.field(
        "attachment_size_limit",
        decode.int,
      )
      decode.success(ApplicationCommand(
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
    "3" -> {
      use id <- decode.field("id", decode.string)
      use application_id <- decode.field("application_id", decode.string)
      use data <- decode.field("data", data.message_component_decoder())
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
      use message <- decode.field("message", decode.dynamic)
      use permissions <- decode.field("permissions", decode.string)
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
      use entitlements <- decode.field(
        "entitlements",
        decode.list(decode.dynamic),
      )
      use authorizing_integration_owners <- decode.field(
        "authorizing_integration_owners",
        decode.list({
          use a <- decode.field(0, decode.string)
          use b <- decode.field(1, decode.dynamic)

          decode.success(#(a, b))
        }),
      )
      use context <- decode.field("context", decode.dynamic)
      use attachment_size_limit <- decode.field(
        "attachment_size_limit",
        decode.int,
      )
      decode.success(MessageComponent(
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
        message:,
        permissions:,
        locale:,
        guild_locale:,
        entitlements:,
        authorizing_integration_owners:,
        context:,
        attachment_size_limit:,
      ))
    }
    "4" -> {
      use id <- decode.field("id", decode.string)
      use application_id <- decode.field("application_id", decode.string)
      use data <- decode.field("data", data.application_command_decoder())
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
      use permissions <- decode.field("permissions", decode.string)
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
      use entitlements <- decode.field(
        "entitlements",
        decode.list(decode.dynamic),
      )
      use authorizing_integration_owners <- decode.field(
        "authorizing_integration_owners",
        decode.list({
          use a <- decode.field(0, decode.string)
          use b <- decode.field(1, decode.dynamic)

          decode.success(#(a, b))
        }),
      )
      use context <- decode.field("context", decode.dynamic)
      use attachment_size_limit <- decode.field(
        "attachment_size_limit",
        decode.int,
      )
      decode.success(ApplicationCommandAutocomplete(
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
    "5" -> {
      use id <- decode.field("id", decode.string)
      use application_id <- decode.field("application_id", decode.string)
      use data <- decode.field("data", data.modal_submit_decoder())
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
      use message <- decode.field("message", decode.dynamic)
      use permissions <- decode.field("permissions", decode.string)
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
      use entitlements <- decode.field(
        "entitlements",
        decode.list(decode.dynamic),
      )
      use authorizing_integration_owners <- decode.field(
        "authorizing_integration_owners",
        decode.list({
          use a <- decode.field(0, decode.string)
          use b <- decode.field(1, decode.dynamic)

          decode.success(#(a, b))
        }),
      )
      use context <- decode.field("context", decode.dynamic)
      use attachment_size_limit <- decode.field(
        "attachment_size_limit",
        decode.int,
      )
      decode.success(ModalSubmit(
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
        message:,
        permissions:,
        locale:,
        guild_locale:,
        entitlements:,
        authorizing_integration_owners:,
        context:,
        attachment_size_limit:,
      ))
    }
    _ ->
      decode.failure(
        Ping(id: "", application_id: "", token: "", version: -1),
        "Interaction",
      )
  }
}
