import gleam/option.{type Option}
import interaction/base
import resolved.{type Resolved}

pub type Interaction {
  Interaction(
    name: String,
    resolved: Resolved,
    guild_id: Option(String),
    target_id: Option(String),
  )
}

pub type Command(bot, success, failure) {
  Command(
    name: String,
    name_locales: List(#(String, String)),
    description: String,
    description_locales: List(#(String, String)),
    default_member_permissions: Option(String),
    nsfw: Bool,
    integration_types: List(base.ApplicationIntegration),
    contexts: List(base.Context),
    version: String,
    handler: Handler(bot, success, failure),
  )
}

pub type Handler(bot, success, failure) =
  fn(Interaction, bot) -> Result(success, failure)
