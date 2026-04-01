import gleam/dict.{type Dict}
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
  Data(
    custom_id: String,
    components: Dict(String, Dynamic),
    resolved: Option(Resolved),
  )
}
