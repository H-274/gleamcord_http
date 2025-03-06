import gleam/option.{type Option}
import interaction/base
import interaction/response
import resolved.{type Resolved}

pub type Interaction {
  Interaction(
    name: String,
    resolved: Resolved,
    guild_id: Option(String),
    target_id: Option(String),
  )
}

pub type Command(bot) {
  Command(
    name: String,
    name_locales: List(#(String, String)),
    description: String,
    description_locales: List(#(String, String)),
    default_member_permissions: Option(String),
    nsfw: Bool,
    integration_types: List(base.ApplicationIntegration),
    contexts: List(base.Context),
    handler: Handler(bot),
  )
}

pub fn new_command(
  name: String,
  description: String,
  integration_types: List(base.ApplicationIntegration),
  contexts: List(base.Context),
) {
  Command(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    default_member_permissions: option.None,
    nsfw: False,
    integration_types:,
    contexts:,
    handler: fn(_, _) { panic as "You must define a handler" },
  )
}

pub fn command_name_locales(
  command: Command(_),
  locales name_locales: List(#(String, String)),
) {
  Command(..command, name_locales:)
}

pub fn command_description_locales(
  command: Command(_),
  locales description_locales: List(#(String, String)),
) {
  Command(..command, description_locales:)
}

pub fn command_default_member_perms(command: Command(_), perms: String) {
  Command(..command, default_member_permissions: option.Some(perms))
}

pub fn command_nsfw(command: Command(_), nsfw: Bool) {
  Command(..command, nsfw:)
}

pub fn with_command_handler(
  command: Command(success),
  handler: fn(Interaction, bot) -> Result(response.Success, response.Failure),
) {
  Command(..command, handler:)
}

pub type Handler(bot) =
  fn(Interaction, bot) -> Result(response.Success, response.Failure)
