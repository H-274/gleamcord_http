import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option}
import locale.{type Locale}

/// TODO replace dynamics
pub type Interaction {
  Interaction(
    id: String,
    application_id: String,
    data: Data,
    guild: Option(Dynamic),
    guild_id: Option(String),
    channel: Option(Dynamic),
    channel_id: Option(String),
    member: Option(String),
    user: Option(Dynamic),
    token: String,
    version: Int,
    message: Option(Dynamic),
    app_permissions: String,
    locale: Locale,
    guild_locale: Option(Locale),
    entitlements: List(Dynamic),
    authorizing_integration_owners: Dict(Dynamic, Dynamic),
    context: Dynamic,
  )
}

pub type Data {
  Data(id: String, name: String)
}
