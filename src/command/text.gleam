import command/response.{type Response}
import entities/integration.{type Integration}
import entities/interaction_context.{type InteractionContext}
import entities/locale.{type Locale}

pub opaque type Command {
  Command(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    // TODO Command options
    options: List(Nil),
    default_member_permissions: String,
    integration_types: List(Integration),
    contexts: List(InteractionContext),
    nsfw: Bool,
    handler: Handler,
  )
}

pub fn command(
  name name: String,
  description description: String,
  options options: List(Nil),
  integ_types integration_types: List(Integration),
  contexts contexts: List(InteractionContext),
  handler handler: Handler,
) {
  Command(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    options:,
    default_member_permissions: "",
    integration_types:,
    contexts:,
    nsfw: False,
    handler:,
  )
}

pub fn name_locales(command: Command, name_locales: List(#(Locale, String))) {
  Command(..command, name_locales:)
}

pub fn description_locales(
  command: Command,
  description_locales: List(#(Locale, String)),
) {
  Command(..command, description_locales:)
}

pub fn default_member_permissions(
  command: Command,
  default_member_permissions: String,
) {
  Command(..command, default_member_permissions:)
}

pub fn nsfw(command: Command, nsfw: Bool) {
  Command(..command, nsfw:)
}

/// TODO
pub type Handler =
  fn() -> Response
